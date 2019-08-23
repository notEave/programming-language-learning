# Design document for the software package Programming language learning

## Directory tree
```
envroot
+ branches
| + [%branchnum-program-io]
|   + [%tasknum-hello-world]
|     + user-executable
|     + task.pdf
|     + .checks
|       + [%check]
|         + check.sh
|         + conf.txt
|         + check.ms
+ templates
| + [%branchname]
|   + conf.txx
|   | # conf.txt shall contain the full name and creation date of the branch
|   | # Fields: branch, time 
|   + [%taskname]
|     + conf.txt
|     | # Shall contain configuration data for generating a task document
|     | # Fields: task, description, time
|     + [%check]
|     | # Check configuration directory added by create-unit
|       + conf.txt
|       | # Shall contain configuration data for the check
|       | # Fields: notes, stdin, args, stdout, stderr, code
|       + check.sh
|         # Automatically generated check script that shall read its
|         # Configuration from conf.txt in the same directory
|         # Can be modified to add additional checks
+ commands
  + plle.venv
  | # Append the /commands directory to $PATH if it doesnt exist
  | # -r Removes the $PATH entry
  | # Usage: plld.venv [-r]
  + plle.readk
  | # Read keys from a configuration file
  | # -k to read the value of a single key
  | # -f point to configuration file
  | # Forgoing k will list all keys in the file
  | # Usage: plle.readk [-k key] -f file
  + plle.create-unit
  | # Create a new unit (branch, task, check) inside /templates
  | # Created units shall have a sorted number 4-zero padded number
  |   prepended in their names
  | # -c option creates a check
  | # Usage: plle.create-unit -b branch [-t task-name] [-c]
  + plle.compile-check
  | # Compile a single check into a check directory, containing configuration
  |   and a groff ms document with configuration values zipped in
  | # Usage: plle.compile-check check target
  + plle.compile-task
  | # Compile a single task into a task directory, containing all the checks
  | # necessary along with a pdf document for the task
  | # Usage: plle.compile-task task target
  + plle.compile-unit
  | # Compile a branch or a task and move the compiled unit into /branches
  | # Forgoing unit-name in the command will compile all units
  | # Usage: plld.compile-unit -b branch [-t task-name]
  + plle.compile-doc
  | # Compile the .ms documentation of a task into pdf format
  | # Usage: plle.compile-doc path/to/task
  + plle.zip-doc
  | # Take a config file and a formatted document as arguments and zip
  |   the values
  | # of the config file into the document
  | # Usage: plle.zip-doc -c path/to/cfg -d path/to/doc
  + plle.verify
    # Verify an executable using the checks that exist in the
      directory of the executable
    # Usage: plle.verify [-d alternate-directory] executable [args...]
```
        
## Commands

### plle.venv

#### Description

Append `/commands` directory to `PATH`.

#### Synopsis

`source commands/plle.venv [-r]`

#### Options

**-r** --- Remove `/commands` from `PATH`

### plle.readk

#### Description

Read key-value pairs from a configuration file.

#### Synopsis

`plle.readk [-k key] file`

#### Options

**-k** --- Read the value of key from file

#### Examples

```
for key in plle.readk file
do
    plle.readk -k "${key}" file
done
```

### plle.create-unit

#### Description

Copy a template unit file (branch, task or a check).

#### Synopsis

`plle.create-unit [-t task [-c]] branch`

#### Options

**-t** --- Create a task

**-c** --- Create a check, requires **-t**

### plle.zip-doc

#### Description

Zip together a configuration file and a groff ms document.
Zipping happens by finding all keys inside the ms document
and replacing them with the respectful values inside the configuration
file. The result is emitted to stdout.

#### Synopsis

`plle.zip-doc config ms-doc`

### plle.compile-unit

#### Description

Compile a unit configuration into a directory with pdf documentation
and verification checks.

#### Synopsis

`plle.compile-unit unit target`