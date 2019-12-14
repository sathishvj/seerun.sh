A bash script to see and run a specified range of commands in a txt file.

### Samples

```
# to make it executable
chmod +x seerun.sh

# show commands from 2 to 4 in file sample_cmds.txt
./seerun.sh sample_cmds.txt 2 4

# execute commands from 2 to 4 in file sample_cmds.txt
./seerun.sh -e sample_cmds.txt 2 4

# confirm before executing commands from 2 to 4 in file sample_cmds.txt
./seerun.sh -ec sample_cmds.txt 2 4
```
