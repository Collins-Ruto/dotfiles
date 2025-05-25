function i --wraps='sudo pacman -S ' --description 'alias i sudo pacman -S '
  sudo pacman -S  $argv; 
end
