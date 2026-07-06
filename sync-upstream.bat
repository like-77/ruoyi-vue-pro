@echo off
chcp 65001 >nul
echo ================================
echo 同步原仓库更新脚本
echo ================================
echo.
echo 【推荐方式】使用 GitHub 网页同步：
echo 1. 打开 https://github.com/like-77/ruoyi-vue-pro
echo 2. 点击 "Sync fork" 按钮
echo 3. 点击 "Update branch" 确认
echo 4. 运行本脚本拉取到本地
echo.
echo 【命令行方式】直接使用本脚本：
echo - 从上游仓库拉取更新
echo - 合并到本地分支
echo - 推送到你的 GitHub fork
echo.
echo ================================
echo.

:menu
echo 请选择同步方式：
echo [1] 从 origin (你的 fork) 拉取（推荐）
echo [2] 从 upstream (原仓库) 合并并推送
echo [3] 退出
echo.
set /p choice="请输入选项 [1-3]: "

if "%choice%"=="1" goto pull_origin
if "%choice%"=="2" goto sync_upstream
if "%choice%"=="3" goto end
echo 无效选项，请重新选择
goto menu

:pull_origin
echo.
echo ================================
echo 方式1：从你的 fork 拉取最新代码
echo ================================
echo.
echo 提示：请先在 GitHub 网页上点击 "Sync fork" 同步！
echo.
pause

echo [1/3] 拉取 master-jdk17 分支...
git checkout master-jdk17
git pull origin master-jdk17

echo.
echo [2/3] 拉取 master 分支...
git checkout master
git pull origin master

echo.
echo [3/3] 拉取 develop 分支...
git checkout develop
git pull origin develop

echo.
echo ✅ 拉取完成！
goto end

:sync_upstream
echo.
echo ================================
echo 方式2：从原仓库合并更新
echo ================================

REM 获取最新的上游代码
echo.
echo [1/4] 正在从原仓库拉取最新代码...
git fetch upstream
if %errorlevel% neq 0 (
    echo ❌ 错误：拉取失败！
    pause
    exit /b 1
)

REM 同步 master-jdk17 分支
echo.
echo [2/4] 正在同步 master-jdk17 分支...
git checkout master-jdk17
git merge upstream/master-jdk17
if %errorlevel% neq 0 (
    echo ⚠️  合并出现冲突，请手动解决后运行：
    echo    git add .
    echo    git commit
    echo    git push origin master-jdk17
    pause
    exit /b 1
)
git push origin master-jdk17

REM 同步 master 分支
echo.
echo [3/4] 正在同步 master 分支...
git checkout master
git merge upstream/master
if %errorlevel% neq 0 (
    echo ⚠️  合并出现冲突，请手动解决
    pause
    exit /b 1
)
git push origin master

REM 同步 develop 分支
echo.
echo [4/4] 正在同步 develop 分支...
git checkout develop
git merge upstream/develop
if %errorlevel% neq 0 (
    echo ⚠️  合并出现冲突，请手动解决
    pause
    exit /b 1
)
git push origin develop

echo.
echo ✅ 所有分支同步完成！
goto end

:end
echo.
echo ================================
pause
