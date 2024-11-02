File: src/components/ARSDashboard/**tests**/AssessmentDetailsTable-test.js

Before (0,0)-(110,0):

```javascript
import AssessmentDetailsTable from '../AssessmentDetailsTable'

jest.unmock('../AssessmentDetailsTable')
jest.unmock('../AssetDetailsTable')
jest.unmock('../../common/ReactTable')
jest.unmock('../../common/ReactTable/DefaultThComponent')
jest.unmock('../../common/ReactTable/DefaultTdComponent')
jest.unmock('../../common/ReactTable/DefaultLoadingComponent')

describe('AssessmentDetailsTable', () => {
  let wrapper
  const threeMonthsAgoTimestamp = '2022-03-30T00:00:00'
  const sixMonthsAgoTimestamp = '2021-12-30T00:00:00'
  const oneYearAgoTimestamp = '2021-06-30T00:00:00'
  const currentTimestamp = '2022-06-30T00:00:00'
  const getTimestamp = jest.fn(() => Date.parse(currentTimestamp))

  const props = {
    isLoading: false,
    perspective: { getTimestamp },
    assessmentScores: [
      {
        _timestamp: threeMonthsAgoTimestamp,
        _type: 'web',
        listing_uid: 'g1s4inafb7',
        score: 9.8
      },
      {
        _timestamp: sixMonthsAgoTimestamp,
        _type: 'web',
        listing_uid: 'g1s4inafb7',
        score: 8.8
      },
      {
        _timestamp: oneYearAgoTimestamp,
        _type: 'web',
        listing_uid: 'g1s4inafb7',
        score: 5.0
      }
    ],
    assessmentListings: [{ codename: 'a_listing', id: 1, name: 'an_org-webListing', slug: 'g1s4inafb7' }],
    onRowMouseEnter: jest.fn(),
    onRowMouseLeave: jest.fn(),
    assetDetailsTableProps: {
      assetScores: [
        {
          asset_uid: 'asset1',
          vulnerability_ids: ['vuln1'],
          _timestamp: threeMonthsAgoTimestamp,
          _type: 'web',
          listing_uid: 'g1s4inafb7',
          score: 9.8
        },
        {
          asset_uid: 'asset2',
          vulnerability_ids: ['vuln2'],
          _timestamp: sixMonthsAgoTimestamp,
          _type: 'web',
          listing_uid: 'g1s4inafb7',
          score: 8.8
        },
        {
          asset_uid: 'asset3',
          vulnerability_ids: ['vuln3'],
          _timestamp: oneYearAgoTimestamp,
          _type: 'web',
          listing_uid: 'g1s4inafb7',
          score: 5.0
        }
      ],
      assetListings: [{ codename: 'a_listing', id: 1, name: 'an_org-webListing', slug: 'g1s4inafb7' }],
      assetVulnerabilities: [
        {
          created_at: Date.parse(threeMonthsAgoTimestamp),
          cvss: 9.8,
          cvss_final: '9.8',
          id: 'vuln-1',
          remediation_status: 'Closed',
          severity: 'critical',
          title: 'PV Flow Test1',
          vulnerability_status: 2
        },
        {
          created_at: Date.parse(sixMonthsAgoTimestamp),
          cvss: 8.8,
          cvss_final: '8.8',
          id: 'vuln-2',
          remediation_status: 'Open',
          severity: 'critical',
          title: 'PV Flow Test2',
          vulnerability_status: 2
        },
        {
          created_at: Date.parse(oneYearAgoTimestamp),
          cvss: 5.0,
          cvss_final: '5.0',
          id: 'vuln-3',
          remediation_status: 'Open',
          severity: 'critical',
          title: 'PV Flow Test3',
          vulnerability_status: 3
        }
      ],
      onRowMouseEnter: jest.fn()
    }
  }

  beforeAll(() => (wrapper = getWrapper(AssessmentDetailsTable, props, true)))

  describe('rendered content', () => {

```

After (116,6)-(129,2):

```javascript

  })

  describe('when overlay props is set', () => {
    beforeAll(() => wrapper.find('ARSDashboardAssessmentDetailsTable').setState({ overlayListingUid: 'g1s4inafb7' }))

    afterAll(() => wrapper.find('ARSDashboardAssessmentDetailsTable').setState({ overlayListingUid: undefined }))

    it('overlay with asset details shows up', () => {
      expect(wrapper.find('ARSDashboardAssetDetailsTable')).toHaveLength(1)
    })
  })
})
```

Selected (110,0)-(116,6):

```javascript
it("renders table accordingly", () => {
  expect(wrapper.find("ClientReactTable")).toHaveLength(1);
  expect(
    wrapper.find(
      'TdComponent.ars-asset-details-table-asset-name[title=asset1"]',
    ),
  ).toBeTruthy();
  expect(
    wrapper.find(
      'TdComponent.ars-asset-details-table-asset-name[title="asset2"]',
    ),
  ).toBeTruthy();
  expect(
    wrapper.find(
      'TdComponent.ars-asset-details-table-asset-name[title="asset3"]',
    ),
  ).toBeTruthy();
  expect(wrapper.find("TrGroupComponent")).toHaveLength(1);
});
```

Instructions:
Convert this enzyme test to RTL. Don't create new tests, just convert the existing ones.
