return {
    'theprimeagen/harpoon',
    keys = {
        {"<leader>a", "<CMD>lua require(\"harpoon.mark\").add_file()<CR>", desc = "Add file to harpoon menu"},
        {"<C-e>", "<CMD>lua require(\"harpoon.ui\").toggle_quick_menu()<CR>", desc = "Open harpoon UI"},
        {"<leader>1", "<CMD>lua require(\"harpoon.ui\").nav_file(1)<CR>", desc = "Navigate to file 1"},
        {"<leader>2", "<CMD>lua require(\"harpoon.ui\").nav_file(2)<CR>", desc = "Navigate to file 2"},
        {"<leader>3", "<CMD>lua require(\"harpoon.ui\").nav_file(3)<CR>", desc = "Navigate to file 3"},
        {"<leader>4", "<CMD>lua require(\"harpoon.ui\").nav_file(4)<CR>", desc = "Navigate to file 4"},
    }
}
