function lr
eza -lR --icons --group --classify --ignore-glob='node_modules|target|dist|build|out|.git|__pycache__|.venv|env|venv|.idea|.vscode|.DS_Store|.cache|*.egg-info|.mypy_cache|*.log|*.tmp|*.bak' $argv
end
