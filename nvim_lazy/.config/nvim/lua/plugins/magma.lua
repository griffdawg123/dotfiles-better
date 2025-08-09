return {
  'dccsillag/magma-nvim',
  event = 'VeryLazy',
  build = ':UpdateRemotePlugins',
  keys = {
    { '<leader>r', '<cmd>MagmaEvaluateOperator<cr>', desc = 'Magma Evaluate Operator' },
    { '<leader>R', '<cmd>MagmaEvaluateLine<cr>', desc = 'Magma Evaluate Line' },
    { '<leader>rr', '<cmd>MagmaEvaluateFile<cr>', desc = 'Magma Evaluate File' },
    { '<leader>rc', '<cmd>MagmaReevaluateCell<cr>', desc = 'Magma Reevaluate Cell' },
    { '<leader>rs', '<cmd>MagmaShowOutput<cr>', desc = 'Magma Show Output' },
  },
}
