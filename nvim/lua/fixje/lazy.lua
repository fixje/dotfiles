require("lazy").setup({
        -- { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
        { "rebelot/kanagawa.nvim" },
        { "dracula/vim" },
        { "theprimeagen/harpoon" },
        { "mbbill/undotree" },
        { "godlygeek/tabular" },
        { "preservim/vim-markdown" },
        -- on Arch install the font packages `pacman -S ttf-hack-nerd ttf-roboto-mono-nerd`
        { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },
        -- on Arch install the font packages `pacman -S powerline-fonts`
        { "vim-airline/vim-airline" },
        { "opdavies/toggle-checkbox.nvim" },

        {
                "numToStr/Comment.nvim",
                opts = {
                        -- add any options here
                },
                lazy = false,
        },
        { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
        {
                "nvim-treesitter/nvim-treesitter",
                dependencies = {
                        { "windwp/nvim-ts-autotag", opts = {} },
                },
                build = ":TSUpdate",
                event = "BufReadPost",
                opts = {
                        auto_install = false,
                        ensure_installed = {
                                "java",
                                "javascript",
                                "typescript",
                                "html",
                                "json",
                                "css",
                                "lua",
                                "go",
                                "markdown",
                                "proto",
                                "diff",
                                "bash",
                                "python"
                        },
                        highlight = { enable = true },
                        indent = { enable = true },
                }
        },
        --- Uncomment these if you want to manage LSP servers from neovim
        {"williamboman/mason.nvim"},
        {"williamboman/mason-lspconfig.nvim"},

        {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
        {"neovim/nvim-lspconfig"},
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/nvim-cmp"},
        {"L3MON4D3/LuaSnip"},
})
