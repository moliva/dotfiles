# aliases

# completion function
_jiraffe () {
    local -a _1st_arguments _create_dopts _common_dopts _show_dopts _components_dopts _getcomponents
    local expl
    typeset -A opt_args

    _common_dopts=(
	'(-t)-t[Jira issue type]:issue type:(Bug Improvement "New Feature" Impediment Task Story)'
	'(-s)-s[Current sprint number]:sprint number'
	'(-p)-p[Project ID]:project key:(STUDIO MULE AUTOMATION EE APIKIT ION SIT)'
    )

    _components_dopts=(
    	'*:project key:(STUDIO MULE AUTOMATION EE APIKIT ION SIT)'
    )

   _show_dopts=(
    	'*:issue key:'
    )

    _getcomponents() {
	    compadd -d $(echo (`jiraffe components $words[CURRENT-2] | grep name | sed -e 's/.*"name" : \(.*\)/\1/g'`))
    }

    _create_dopts=(
    	'(-r)-r[Reporter]:jira id:($JIRA_ID)'
	'(-a)-a[Assignee]:jira id:($JIRA_ID)'
	'(-pr)-pr[Issue priority]:priority:(Major Critical Blocker Trivial Minor)'
	'(-c)-c[Component name]:component name:(Canvas DataMapper ApiKit Automation Batch Build Classpath "Cloud Connectors" Commons Components DataSense Debugger "Document Generation" Documentation "Drag and Drop" "Embedded Server" Examples Executino "Import / Export" Installation Maven "MEL Autocompletion" Metadata Plugin "Project Structure" Release SCM Tests "Update Site" Usability "User Interface" Validations "XML Auto Completion" "XML Generation")'
	'(-cs)-cs[Components]:components names:_getcomponents'
    )

    _1st_arguments=(
    'components:Display components for a given project' \
    'create:Create a jira issue and return the issue ID' \
    'default:Show current default values' \
    'show:Display issue information' \
    'update:Update current default values' \
    'help:Display help' \
    )
     _arguments \
    '*:: :->subcmds' && return 0 
     
    if (( CURRENT == 1 )); then
        _describe -t commands "jiraffe subcommand" _1st_arguments
        return
    fi

    case "$words[1]" in
        create)
	_arguments \
	$_create_dopts \
	$_common_dopts \
        ;;
        update)
	_arguments \
	$_common_dopts \
        ;;
	show)
	_arguments \
	$_show_dopts \
	;;
	components)
	_arguments \
	$_components_dopts \
	;;
    esac

}

compdef _jiraffe jiraffe
