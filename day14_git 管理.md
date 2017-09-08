### git版本使用
Git是一个分布式版本管理系统，是为了更好地管理Linux内核开发而创立的。
Git可以在任何时间点，把文档的状态作为更新记录保存起来。因此可以把编辑过的文档复原到以前的状态，也可以显示编辑前后的内容差异。
而且，编辑旧文件后，试图覆盖较新的文件的时候（即上传文件到服务器时），系统会发出警告，因此可以避免在无意中覆盖了他人的编辑内容。

### git怎么实现还原  查看以前的更新记录   
管理历史记录的数据库
在git的目录下面有一个.git文件 里面就是记录文件或目录状态的地方,存储着内容修改的历史记录,我们可以通过读取历史记录来修改文件 差异备份

###  远程数据库和本地数据库
git数据库分为远程数据库和本地数据库两种
* 远程数据库: 配有专用的服务器，为了多人共享而建立的数据库
* 本地数据库: 为了方便用户个人使用，在自己的机器上配置的数据库。
数据库分为远程和本地两种。平时用手头上的机器在本地数据库上操作就可以了。如果想要公开在本地数据库中修改的内容，把内容上传到远程数据库就可以了。另外，通过远程数据库还可以取得其他人修改的内容。

git 下载地址 
https://git-scm.com/download/win

git参考文档
http://www.jianshu.com/p/55496ff224e9

git config --global user.name "you name"
设置你的名字 强制性的
git config --global user.email "you email"
设置你的邮箱 
git config --global color.ui auto
开启命令和输出的颜色

git init [project-name]
创建一个新的本地仓库

git clone [url]
下载一个项目的所有的历史版本

git status
列出所有的正在变更的文件到提交

git diff
显示文件不同的地方   
diff 只在没有add之前生效 

git add [file]
为准备版本编写快照。

git diff --staged
显示当前版本和最后一个文件版本之间的文件差异

git reset [file]
结果文件，但保留其内容  * 

git commit -m "asdasdasd"
在版本历史中永久记录文件快照  提交文件到本地仓库
---
git branch
列出所有的本地分支
 
git branch [branch-name]
创建新的分支

git checkout  [branch-name]
切换分支

git merge [branch]
合并分支

git branch -d [branch-name]
删除分支
---
review history[恢复历史]
git log
列出所有的历史版本

git log --follow  [file]
列出一个文件的版本历史，包括重命名

git diff [first-branch]...[second-branch]
显示两个分支之间的内容差异

git show [commit]
输出指定提交的内容变更信息
---
redo commits(重新提交)
git reset [commit]   一般不用
撤消所有提交后[提交]，保持局部变化

git reset --hard [commit]
将所有历史和更改全部丢弃到指定的提交中 
还原到一个指定的提交中去
---
git merge [bookmark]/[branch]
合并本地的分支
git push [alias] [branch] 
提交数据到github
git pull
下载书签历史并包含更改

### 操作分支
git branch cehsi
git branch
git checkout ceshi
vim  ffff
git add ffff
git commit -m 'ceshi'
git chekcout master
git merge ceshi
git branch -d ceshi

### 并行分支
git branch ceshi2
git branch cehsi3
git checkout ceshi2 
vim ceshi2
git add ceshi2
git commit -m 'ceshi2'
git checkout ceshi3
vim ceshi3
git add ceshi3
git commit -m 'ceshi3'
git checkout master
git merge ceshi3

### 时光穿梭机
vim xxxx
git status
git diff xxxx
git add xxxx
git commmit -m  'update xxxx'
git status
* git回退版本
git reset --hard HEAD^    回到上一个版本
git reset --hard HEAD^^    回到上上一个版本
git reset --hard HEAD^100 回到上100个版本
也可以通过commit id =3331232 这个值来回退版本
git reset --hard 3331232

git reflog 查询你做过的命令
HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令git reset --hard commit_id。
穿梭前，用git log可以查看提交历史，以便确定要回退到哪个版本。
要重返未来，用git reflog查看命令历史，以便确定要回到未来的哪个版本。

没有add之前可以使用
git checkout -- [file name]

如果已经add 把文件加入暂存区了怎么办
git reset HEAD [file name]
git checkout -- [file name]

场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。

场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，第二步按场景1操作。

场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考版本回退一节，不过前提是没有推送到远程库



ADD  暂存区
commit 工作区

### 删除文件
rm xxx
git rm xxx
git commit -m 'remove xxx'





