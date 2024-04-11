[{1 :bakpakin/fennel.vim
  :lazy true
  :ft [:fennel]}
  {
  1 :neovim/nvim-lspconfig
  :opts (fn []
             (let [util (require "lspconfig/util")]
                   :servers {
                    :fennel_language_server {
                      :default_config {
                                      ; :cmd "fennel-language-server"
                                      :cmd {1 "/usr/local/bin/fennel"}
                                      :filetypes [:fennel]
                                      :root_dir (util.root_pattern "fnl")
                                      :single_file_support true
                                      :settings {
                                                :fennel {
                                                          :workspace {
                                                            ; If you are using hotpot.nvim or aniseed,
                                                            ; make the server aware of neovim runtime files.
                                                            ; library = vim.api.nvim_list_runtime_paths(),
                                                            ; checkThirdParty = false
                                                          }
                                                          :diagnostics {:globals "vim"}}}}}}))}]
