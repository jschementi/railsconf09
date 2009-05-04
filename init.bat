@echo OFF

doskey hwrl=cd /d %~dp0helloworld\rails
doskey hwrk=cd /d %~dp0helloworld\rack
doskey hws=cd /d %~dp0helloworld\sinatra

doskey arms=cd /d c:\dev\activerecord-mssql-adapter

set PATH=%PATH%;%~dp0jruby-1.2.0\bin

cd %~dp0
