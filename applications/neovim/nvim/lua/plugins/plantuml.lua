return  {
    {
        'skanehira/preview-uml.vim',
        ft = { 'plantuml' },
        init = function()
            vim.g.preview_uml_url = 'http://localhost:8888'
        end

    },
    {
        'weirongxu/plantuml-previewer.vim',
        ft = { 'plantuml' },
        dependencies = {
            'tyru/open-browser.vim',
            'aklt/plantuml-syntax',
        }


    },
}
