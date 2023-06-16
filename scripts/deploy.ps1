@echo off
rem Script para fazer deploy de aplicações em modo silent do Windows para caso onde não possível fazer a implementação das aplicações automaticamente

if "%1" == "/u" goto uninstall
if "%1" == "/i" goto install

:install
	start /wait "%2" /passive /norestart

:uninstall
	start /wait msiexec /uninstall "%2" /passive /norestart
