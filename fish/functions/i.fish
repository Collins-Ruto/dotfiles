function i --wraps='sudo apt install ' --description 'alias i sudo apt install '
  sudo apt install  $argv; 
end
