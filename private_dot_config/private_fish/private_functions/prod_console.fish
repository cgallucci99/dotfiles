function prod_console --wraps='heroku console --app=braven-platform-highlander' --description 'alias prod_console=heroku console --app=braven-platform-highlander'
    heroku console --app=braven-platform-highlander $argv
end
