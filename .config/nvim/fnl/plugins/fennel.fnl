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
                                      :cmd "fennel-language-server"
                                      :filetypes [:fennel]
                                      :root_dir (util.root_pattern "fnl")
                                      :single_file_support true
                                      :settings {
                                                :fennel {
                                                          :workspace {}
                                                          :diagnostics {:globals "vim"}}}}}}))}]
