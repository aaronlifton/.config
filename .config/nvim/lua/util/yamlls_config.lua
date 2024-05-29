local M = {}
M.get_yamlls_config = function()
  if not pcall(require, "yaml-companion") then
    return {
      yaml = {
        validate = true,
        schemaStore = {
          enable = true,
        },
      },
    }
  end

  local yamlls_cfg = require("yaml-companion").setup({
    -- detect k8s schemas based on file content
    builtin_matchers = {
      kubernetes = { enabled = true },
    },

    -- schemas available in Telescope picker
    schemas = {
      result = {
        -- not loaded automatically, manually select with
        -- :Telescope yaml_schema
        {
          name = "Argo CD Application",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
        },
        {
          name = "Argo Workflows",
          uri = "https://raw.githubusercontent.com/argoproj/argo-workflows/main/api/jsonschema/schema.json",
        },
        {
          name = "SealedSecret",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
        },
        -- schemas below are automatically loaded, but added
        -- them here so that they show up in the statusline
        {
          name = "Kustomization",
          uri = "https://json.schemastore.org/kustomization.json",
        },
        {
          name = "GitHub Workflow",
          uri = "https://json.schemastore.org/github-workflow.json",
        },
      },
    },

    lspconfig = {
      settings = {
        yaml = {
          validate = true,
          -- schemaStore = {
          --   enable = true,
          -- },
          schemaStore = {
            enable = false,
            url = "",
          },
          -- schemaStore = {
          --   enable = true,
          --   url = "https://www.schemastore.org/json",
          -- },

          -- schemas from store, matched by filename
          -- loaded automatically
          schemas = vim.tbl_extend(
            "keep",
            require("schemastore").yaml.schemas({
              select = {
                "kustomization.yaml",
                "GitHub Workflow",
              },
            }),
            {
              -- From yaml-companion
              -- ["https://json.schemastore.org/github-workflow.json"] = { "**/.github/workflows/*.yml", "**/.github/workflows/*.yaml", "**/.gitea/workflows/*.yml", "**/.gitea/workflows/*.yaml", "**/.forgejo/workflows/*.yml", "**/.forgejo/workflows/*.yaml" },
              -- ["https://json.schemastore.org/kustomization.json"] = { "kustomization.yaml", "kustomization.yml" }
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                "/.gitlab-ci.yml",
                "/.gitlab/ci/*.yml",
              },
              ["https://aka.ms/configuration-dsc-schema/0.2"] = "/*.dsc.yaml",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                "/docker-compose.{yml,yaml}",
                "/compose.{yml,yaml}",
              },
              ["https://json.schemastore.org/prometheus.json"] = "/prometheus.yml",
            }
          ),
        },
      },
    },
  })
  return yamlls_cfg
end

return M
