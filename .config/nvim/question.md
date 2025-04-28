Here are some files in my 2 projects (frontend_client (js) and backend_synack (ruby on rails)):

## Backend

File: `app/validators/parameter_validator.rb` (1-119)

```ruby
# frozen_string_literal: true

# Validates parameters and returns an array of subproblems for a problem details response
class ParameterValidator
  attr_reader :errors, :params

  def initialize(permitted_params)
    @params = permitted_params
    @errors = []
  end

  def permitted_params
    return nil unless valid?

    @params
  end

  def validate_presence(*keys)
    keys.each do |key|
      next if params[key].present?

      @errors.push({
        name: key.to_s,
        reason: "#{key} is required"
      })
    end
    self
  end

  def validate_boolean(key)
    value = ActiveModel::Type::Boolean.new.cast(params[key])
    unless value.in?([true, false])
      @errors.push({
        name: key.to_s,
        reason: "#{key} must be a boolean value"
      })
    end
    params[key] = value
    self
  end

  def validate_inclusion(key, allowed_values, message = nil)
    if params[key].present? && !params[key].in?(allowed_values)
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be one of: #{allowed_values.join(', ')}"
      })
    end
    self
  end

  def validate_string(key, message = nil)
    if params[key].present? && !params[key].is_a?(String)
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be a string"
      })
    end
    self
  end

  def validate_gt(key, min_value, message = nil)
    if params[key].present? && (!params[key].is_a?(Numeric) || params[key] <= min_value)
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be greater than #{min_value}"
      })
    end
    self
  end

  def validate_lt(key, max_value, message = nil)
    if params[key].present? && (!params[key].is_a?(Numeric) || params[key] >= max_value)
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be less than #{max_value}"
      })
    end
    self
  end

  def validate_positive_integer(key, message = nil)
    if params[key].present? && (!params[key].is_a?(Integer) || !params[key].positive?)
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be a positive integer"
      })
    end
    self
  end

  def validate_array_presence(key, message = nil)
    if params[key].blank?
      @errors.push({
        name: key.to_s,
        reason: message || "At least one #{key.to_s.singularize} is required"
      })
    end
    self
  end

  def validate_array_positive_integers(key, message = nil)
    if params[key].present? && !params[key].all? { |item| item.is_a?(Integer) && item.positive? }
      @errors.push({
        name: key.to_s,
        reason: message || "#{key} must be an array of positive integers"
      })
    end
    self
  end

  def valid?
    @errors.empty?
  end

  def error?
    !valid?
  end
end
```

File: `app/controllers/web_api/client/v2/assessments_controller.rb` (1-364) In this controller, focus on the `#create`
action, as it has the new abstractions I introduced. You can ignore the `#index` action.

```ruby
# frozen_string_literal: true

# This is only included so the class is loaded in dev.
require_relative '../../../../../app/validators/parameter_validator.rb'

class WebApi::Client::V2::AssessmentsController < WebApi::Client::V2::BaseController
  AssessmentPresenter = ::Api::Client::V2::AssessmentPresenter
  private_constant :AssessmentPresenter

  SPRINT_COUNT_SORT_PARAMS = %w[
    pending_test_count
    scheduled_test_count
    active_test_count
    paused_test_count
    completed_test_count
  ].freeze
  private_constant :SPRINT_COUNT_SORT_PARAMS
  SORT_BY_ALLOWLIST = %w[
    name
    created_at
    pending_test_count
    scheduled_test_count
    active_test_count
    paused_test_count
    completed_test_count
    total_vulnerability_count
  ].freeze
  SORT_BY_DEFAULT = 'created_at'
  SORT_ORDER_ALLOWLIST = %w[DESC ASC].freeze
  SORT_ORDER_DEFAULT = 'DESC'
  private_constant :SORT_BY_ALLOWLIST
  private_constant :SORT_BY_DEFAULT
  private_constant :SORT_ORDER_ALLOWLIST
  private_constant :SORT_ORDER_DEFAULT

  PER_PAGE_DEFAULT = 10
  PER_PAGE_MAX = 50
  private_constant :PER_PAGE_DEFAULT
  private_constant :PER_PAGE_MAX

  ASSESSMENT_TYPE_PARAM_ALLOWLIST = %w[web host api mobile].freeze
  private_constant :ASSESSMENT_TYPE_PARAM_ALLOWLIST

  before_action do
    require_feature_flag(Feature::CLIENT_ASSESSMENTS_V2)
  end

  def index
    permitted_params = validate_index_parameters!(params)
    return if performed?

    page = permitted_params[:page].present? ? Integer(permitted_params[:page]) : 1
    per_page = permitted_params[:perPage].present? ? Integer(permitted_params[:perPage]) : PER_PAGE_DEFAULT
    offset = per_page * (page - 1)

    organization_profile_id = OrganizationProfile.find_by(slug: params[:organization_uid]).id
    listings = Listing.where(organization_profile_id: organization_profile_id)
    listings = filter_listings_by_parameters(listings.non_easm, permitted_params)
    listings = policy_scope(listings)

    pagination = get_pagination_metadata(listings.count, page, per_page, params)

    listings, pluck_required = sort_listings_by_parameters(listings, permitted_params)
    listings = listings
      .offset(offset)
      .limit(per_page)

    if pluck_required
      listing_ids = listings.load.pluck(:id)
      listings = Listing.where(id: listing_ids).order(Arel.sql("array_position(ARRAY[#{listing_ids.join(', ')}], \"listings\".\"id\")"))
    end

    listings = listings.includes(:category).load

    listing_ids = listings.pluck(:id)
    sprint_counts = calculate_sprint_counts(listing_ids)
    vulnerability_counts = calculate_vulnerability_counts(listing_ids)

    render(status: :ok, json: AssessmentPresenter.index(listings, sprint_counts, vulnerability_counts, pagination))
  end

  def create
    listing_create_params = validate_create_params!
    return if performed?

    listing = Listing.new(org_listing_group_id: listing_create_params[:orgListingGroupId])
    authorize(listing, :create?)

    organization_profile = OrganizationProfile.find_by!(slug: params[:organization_uid])
    service = Client::Assessment::Create.new(
      listing: listing,
      params: listing_create_params.to_h,
      organization_profile: organization_profile,
      current_user: current_user.user
    )

    begin
      listing = service.call
      render(status: :created, json: AssessmentPresenter.show(listing))
    rescue Timeout::Error
      render(
        problem: ProblemDetails.internal_server_problem(organization_uid: params[:organization_uid]),
        status: :internal_server_error
      )
    rescue BaseService::Error => e
      if service.validation_errors.any?
        render(
          problem: ProblemDetails.validation_problem(errors: service.validation_errors, type: :invalid_parameters, organization_uid: params[:organization_uid]),
          status: :bad_request
        )
      else
        render(
          problem: ProblemDetails.operation_problem(detail: e.message, organization_uid: params[:organization_uid]),
          status: :unprocessable_entity
        )
      end
    end
  end

  private

  def validate_index_parameters!(params)
    invalid_params = []

    if params['sort'].present? && SORT_BY_ALLOWLIST.exclude?(params['sort'])
      invalid_params.push({
        name: 'sort',
        reason: "sort must be one of: #{SORT_BY_ALLOWLIST.join(', ')}"
      })
    end

    if params['sortDir'].present? && SORT_ORDER_ALLOWLIST.exclude?(params['sortDir'].upcase)
      invalid_params.push({
        name: 'sortDir',
        reason: "sortDir must be one of: #{SORT_ORDER_ALLOWLIST.join(', ')}"
      })
    end

    if params['page'].present? && !positive_integer?(params['page'])
      invalid_params.push({
        name: 'page',
        reason: 'page must be a positive integer value'
      })
    end

    if params['perPage'].present? && !positive_integer?(params['perPage'])
      invalid_params.push({
        name: 'perPage',
        reason: 'perPage must be a positive integer value'
      })
    elsif params['perPage'].present? && Integer(params['perPage']) > PER_PAGE_MAX
      invalid_params.push({
        name: 'perPage',
        reason: "perPage cannot be larger than #{PER_PAGE_MAX}"
      })
    end

    if params['search'].present? && !params['search'].is_a?(String)
      invalid_params.push({
        name: 'search',
        reason: 'search must be a string'
      })
    end

    if params['types'].present? && params['types'].any? { |assessment_type| ASSESSMENT_TYPE_PARAM_ALLOWLIST.exclude?(assessment_type) }
      invalid_params.push({
        name: 'types[]',
        reason: "types[] values must be one of: #{ASSESSMENT_TYPE_PARAM_ALLOWLIST.join(', ')}"
      })
    end

    if params['tagIds'].present? && params['tagIds'].any? { |tag_id| !positive_integer?(tag_id) }
      invalid_params.push({
        name: 'tagIds[]',
        reason: 'Valid tagIds[] values are positive integers'
      })
    end

    if invalid_params.present?
      # Add error codes to the invalid params
      invalid_params_with_codes = invalid_params.map do |param|
        param_with_code = param.dup
        if param[:reason].include?('must be one of')
          param_with_code[:code] = 'INVALID_OPTION'
        elsif param[:reason].include?('must be a positive integer')
          param_with_code[:code] = 'INVALID_INTEGER'
        elsif param[:reason].include?('cannot be larger than')
          param_with_code[:code] = 'VALUE_TOO_LARGE'
        elsif param[:reason].include?('must be a string')
          param_with_code[:code] = 'INVALID_STRING'
        else
          param_with_code[:code] = 'INVALID_PARAMETER'
        end
        param_with_code
      end

      error_details_object = get_error_details_object(
        type: :invalid_query_parameters,
        organizationUid: params[:organization_uid],
        invalidParams: invalid_params_with_codes
      )
      headers['Content-Type'] = 'application/problem+json'
      return render(status: :bad_request, json: error_details_object)
    end

    params.permit(:sort, :sortDir, :page, :perPage, :search, types: [], tagIds: [])
  end

  def filter_listings_by_parameters(listings, params)
    filtered_listings = listings
    tag_ids_param = params[:tagIds]
    types_param = params[:types]
    search_param = params[:search]

    if tag_ids_param.present?
      filtered_listings = filtered_listings.joins(:tags).where(tags: { id: tag_ids_param })
    end

    if types_param.present?
      category_names = types_param.map do |assessment_type_param|
        case assessment_type_param
        when 'web'
          ::Category::WEB_APPLICATION
        when 'host'
          ::Category::HOST
        when 'api'
          ::Category::API
        when 'mobile'
          ::Category::MOBILE
        end
      end
      category_names = category_names.uniq
      filtered_listings = filtered_listings.joins(:category).where(category: { name: category_names })
    end

    if search_param&.strip.present?
      search_param = search_param.strip
      filtered_listings = filtered_listings.where('"listings"."name" ILIKE ?', "%#{search_param}%")
    end

    return filtered_listings
  end

  def sort_listings_by_parameters(listings, params)
    sort_by = params[:sort] || SORT_BY_DEFAULT
    sort_order = params[:sortDir].present? ? params[:sortDir].downcase : SORT_ORDER_DEFAULT

    if sort_by == 'total_vulnerability_count'
      listings = listings
        .joins('LEFT OUTER JOIN "vulnerabilities" ON "listings"."id" = "vulnerabilities"."listing_id" AND "vulnerabilities"."accepted" = TRUE')
        .group(:id)
        .select(:id, 'COUNT("vulnerabilities"."id") AS total_vulnerability_count')
        .order({ sort_by => sort_order })

      pluck_required = true
      return listings, pluck_required
    end

    if SPRINT_COUNT_SORT_PARAMS.include?(sort_by)
      sort_by_to_additional_on_clause = {
        pending_test_count: 'AND 1 = 2',
        scheduled_test_count: 'AND "sprints"."actual_start_date" IS NULL AND "sprints"."actual_end_date" IS NULL',
        active_test_count: 'AND "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NULL AND "listings"."testing_paused" != TRUE',
        paused_test_count: 'AND "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NULL AND "listings"."testing_paused" = TRUE',
        completed_test_count: 'AND "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NOT NULL'
      }.with_indifferent_access
      additional_on_clause = sort_by_to_additional_on_clause[sort_by]

      listings = listings
        .joins("LEFT OUTER JOIN \"sprints\" ON \"listings\".\"id\" = \"sprints\".\"listing_id\" #{additional_on_clause}").group(:id)
        .select(:id, "COUNT(\"sprints\".\"id\") AS #{sort_by}")
        .order({ sort_by => sort_order })

      pluck_required = true
      return listings, pluck_required
    end

    pluck_required = false
    return listings.order({ sort_by => sort_order }), pluck_required
  end

  def calculate_sprint_counts(listing_ids)
    case_statement = <<-SQL.squish
      CASE
        WHEN "sprints"."actual_start_date" IS NULL AND "sprints"."actual_end_date" IS NULL
        THEN 'scheduled'
        WHEN "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NULL AND "listings"."testing_paused" != TRUE
        THEN 'active'
        WHEN "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NULL AND "listings"."testing_paused" = TRUE
        THEN 'paused'
        WHEN "sprints"."actual_start_date" IS NOT NULL AND "sprints"."actual_end_date" IS NOT NULL
        THEN 'completed'
        ELSE 'invalid'
      END
    SQL

    default_values = listing_ids.index_with do |_listing_id|
      {
        pending: 0,
        scheduled: 0,
        active: 0,
        paused: 0,
        completed: 0
      }
    end

    Sprint.joins(:listing)
      .where(listing_id: listing_ids)
      .group("\"listings\".\"id\", #{case_statement}")
      .select(
        '"listings"."id" AS "listing_id"',
        "#{case_statement} AS status",
        'COUNT(*) AS "sprint_count"'
      )
      .each_with_object(default_values) do |row, hash|
        hash[row[:listing_id]][row[:status]] = row[:sprint_count]
      end
  end

  def calculate_vulnerability_counts(listing_ids)
    result = Vulnerability
      .accepted
      .where(listing_id: listing_ids)
      .group(:listing_id)
      .select(
        '"vulnerabilities"."listing_id" AS "listing_id"',
        'COUNT(*) AS "vulnerability_count"'
      )

    result.each_with_object({}) do |row, hash|
      hash[row[:listing_id]] = row[:vulnerability_count]
    end
  end

  def validate_create_params!
    permitted_params = params.permit(
      :name,
      :description,
      :authenticationSelfRegistrationEnabled,
      :orgListingGroupId,
      :gatewayId,
      :categoryId,
      tagNames: [],
      ownerContactsAttributes: [:userId],
      files: [:signedId],
      assets: [:uid]
    )

    validator = ParameterValidator.new(permitted_params)

    validator
      .validate_presence(:name, :orgListingGroupId, :categoryId)
      .validate_boolean(:authenticationSelfRegistrationEnabled)
      .validate_array_presence(:assets)
      # .validate_array_presence(:ownerContactsAttributes)

    return permitted_params if validator.valid?

    render(
      problem: ProblemDetails.validation_problem(errors: validator.errors, type: :invalid_parameters, organization_uid: params[:organization_uid]),
      status: :bad_request
    )
  end
end
```

File: `lib/problem_details.rb` (1-78)

```ruby
# frozen_string_literal: true

# Problem details object that follows RFC 7807 standard
class ProblemDetails
  attr_reader :type, :title, :detail, :organization, :additional_params

  def self.internal_server_problem(organization_uid:, title: nil, detail: nil, **params)
    new(
      type: :internal_server_error,
      organization_uid: organization_uid,
      title: title,
      detail: detail,
      **params
    )
  end

  def self.operation_problem(detail:, organization_uid:, title: nil, **params)
    new(
      type: :operation_not_valid,
      organization_uid: organization_uid,
      title: title,
      detail: detail,
      **params
    )
  end

  # For validation problems, `type` will be invalid_parameters, invalid_query_parameters, missing_required_parameters, or file_size_exceeded
  def self.validation_problem(errors:, organization_uid:, type:, **params)
    new(
      type: type,
      organization_uid: organization_uid,
      invalidParams: errors,
      **params
    )
  end

  def self.not_found_problem(detail:, organization_uid: nil, **params)
    new(
      type: :http_not_found,
      organization_uid: organization_uid,
      detail: detail,
      **params
    )
  end

  def self.file_size_problem(detail:, organization_uid: nil, **params)
    new(
      type: :file_size_exceeded,
      organization_uid: organization_uid,
      detail: detail,
      **params
    )
  end

  def initialize(type:, organization_uid:, **params)
    @type = "https://synack.com/probs/#{type}"
    @title = params.delete(:title) || I18n.t("problems.#{type}.title", default: nil)
    @detail = params.delete(:detail)
    @detail ||= I18n.t("problems.#{type}.detail", default: nil) unless params[:invalidParams]
    @organization = "organizations/#{organization_uid}" if organization_uid
    if @organization && params[:assessment_uid]
      params[:assessment] = "#{@organization}/assessments/#{params.delete(:assessment_uid)}"
    end
    @additional_params = params
  end

  def to_h
    {
      type: type,
      title: title,
      detail: detail,
      organization: organization,
      **additional_params
    }.compact
  end
  # Objects that respond to #to_hash will use that method when converted to JSON via #as_json.
  alias to_hash to_h
end
```

## Frontend

Relevant excerpt from the create assessment form: File: `src/components/Assessments/Form/index.js` (250-275)

```javascript
const onSubmit = async (values) => {
  try {
    const {assessment} = await createAssessment(values);
    if (submitAction.current === FORM_ACTION_CREATE_AND_CONTINUE) {
      // TODO: implement test for this success toast
      triggerSuccessToast({
        description: t('components.AssessmentForm.CREATE_ASSESSMENT_SUCCESS_MESSAGE'),
        options: DEFAULT_TOAST_TRIGGER_OPTS,
      });
      // TODO: Redirect to "Create Test" page https://synackinc.atlassian.net/browse/RD-46569
      history.replace(`create-test/${assessment.id}`);
    } else if (submitAction.current === FORM_ACTION_CREATE_ASSESSMENT_ONLY) {
      triggerSuccessToast({
        description: t('components.AssessmentForm.CREATE_ASSESSMENT_SUCCESS_MESSAGE'),
        options: DEFAULT_TOAST_TRIGGER_OPTS,
      });
      // TODO: Redirect to assessment v2 show? Not clear in https://synackinc.atlassian.net/wiki/spaces/RD/pages/2954592265/Create+Assessment+and+Create+Test+Technical+Design
      history.replace(`assessment-v2-show/${assessment.id}`);
    }
  } catch (error) {
    triggerProblemDetailsToast({
      problemDetails: error.body,
      options: DEFAULT_TOAST_TRIGGER_OPTS,
    });
  }
};
```

File: `src/lib/problemDetailsToast.js` (1-67)

```javascript
import React from 'react';

import {triggerDangerToast} from './alertToast';

import ValidationProblemContent from '@/components/common/sds/ProblemDetails/ValidationProblemContent';
import {processProblemDetailsResponse} from './problemDetails';

// Import types
/**
 * @typedef {import('@/types/api').InvalidParam} InvalidParam
 * @typedef {import('@/types/api').ProblemDetails} ProblemDetails
 */

/**
 * @param {ProblemDetails} errorBody - The body of the problem details response
 * @param {Object} options - Additional options for the toast
 */
export const triggerProblemDetailsToast = ({errorBody, options = {}}) => {
  if (!errorBody) return;

  const problemDetails = processProblemDetailsResponse(errorBody);
  if (!problemDetails) return;

  if (problemDetails.isValidationProblem) {
    return triggerValidationProblemToast({problemDetails, options});
  } else {
    return triggerGenericProblemDetailsToast({problemDetails, options});
  }
};

/**
 * @param {Object} problemDetails - The processed problem details object
 * @param {Object} options - Additional options for the toast
 */
const triggerGenericProblemDetailsToast = ({problemDetails, options = {}}) => {
  const {title, detail} = problemDetails;

  triggerDangerToast({
    header: title,
    description: detail,
    options,
  });
};

/**
 * @param {Object} problemDetails - The processed problem details object
 * @param {Object} options - Additional options for the toast
 */
const triggerValidationProblemToast = ({problemDetails, options = {}}) => {
  const {title, reasons} = problemDetails;

  triggerDangerToast({
    customContent: <ValidationProblemContent title={title} reasons={reasons} />,
    options,
  });
};

/**
 * Extracts the problem type from the problem details object
 * @param {ProblemDetails} problemDetails - The problem details object
 * @returns {string|null} The extracted problem type or null if not found
 */
export const getProblemType = (problemDetails) => {
  if (!problemDetails.type) return null;

  return problemDetails.type.split('/').pop();
};
```

File: `src/components/common/sds/ProblemDetails/ValidationProblemContent.js` (1-32)

```javascript
import React from 'react';
import PropTypes from 'prop-types';
import {TOAST_CLASS} from '../AlertToast';

import './ValidationProblemContent.scss';

const ROOT_CLASS = `${TOAST_CLASS}-validation-problem`;

// Component to display validation problems
const ValidationProblemContent = ({title, reasons}) => (
  <div className={ROOT_CLASS}>
    <h4 className={`${TOAST_CLASS}-header`} data-testid="alertToastValidationTitle">
      {title}
    </h4>
    {reasons && reasons.length > 0 && (
      <ul className={`${ROOT_CLASS}-validation-list`} data-testid="alertToastValidationList">
        {reasons.map((reason, index) => (
          <li key={index} className={`${ROOT_CLASS}-validation-item`}>
            {reason}
          </li>
        ))}
      </ul>
    )}
  </div>
);

ValidationProblemContent.propTypes = {
  title: PropTypes.string.isRequired,
  reasons: PropTypes.arrayOf(PropTypes.string),
};

export default ValidationProblemContent;
```

The frontend project is also using i18next, so we could create a problems namespace (currently it's a json file, but
could make it a dynamic js file if that makes more sense to you): File: `src/lib/i18n/index.ts` (1-30)

```typescript
import i18next from 'i18next';
import {SUPPORT_EMAIL_ADDRESS} from '../../config';
import common from './en/common.json';
import reports from './en/reports';
import problems from './en/problems.json';

export const defaultNS = 'common';
export const resources = {
  en: {
    common: {...common, ...reports},
    problems,
  },
};

i18next.init({
  interpolation: {
    escapeValue: false,
    defaultVariables: {
      supportEmail: SUPPORT_EMAIL_ADDRESS,
    },
    skipOnVariables: false,
  },
  lng: 'en',
  compatibilityJSON: 'v3', // See https://www.i18next.com/misc/migration-guide#v-20-x-x-to-v-21-0-0
  defaultNS,
  resources,
});

export const t = i18next.t.bind(i18next);
export default i18next;
```

What would be the best way to make sure the frontend can display user-friendly error messages, based on a problem
details response?

Would you make any changes to the problem details generated by `ParameterValidator`?

How would you implement `processProblemDetailsResponse`?

Please return the code for these questions, as well as the code for `problems.json` so i can integrate it in my project.
And whatever else you think is relevant.
