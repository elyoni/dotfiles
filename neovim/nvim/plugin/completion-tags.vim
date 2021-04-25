if PlugLoaded("completion-tags")
    let g:completion_chain_complete_list = {
          \ 'default': [
          \    {'complete_items': ['lsp']},
          \    {'complete_items': ['tags']},
          \  ]}

endif
