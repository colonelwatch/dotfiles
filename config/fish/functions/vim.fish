function vim --wraps=nvim --wraps='NVIM_APPNAME=nvim-vim nvim' --description 'alias vim NVIM_APPNAME=nvim-vim nvim'
  NVIM_APPNAME=nvim-vim nvim $argv
        
end
