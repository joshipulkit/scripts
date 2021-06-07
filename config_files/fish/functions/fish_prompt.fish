# Defined interactively
#function fish_prompt --description 'Write out the prompt'
    #set -l last_pipestatus $pipestatus
    #set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
#
    #if not set -q __fish_git_prompt_show_informative_status
        #set -g __fish_git_prompt_show_informative_status 1
    #end
    #if not set -q __fish_git_prompt_hide_untrackedfiles
        #set -g __fish_git_prompt_hide_untrackedfiles 1
    #end
    #if not set -q __fish_git_prompt_color_branch
        #set -g __fish_git_prompt_color_branch magenta --bold
    #end
    #if not set -q __fish_git_prompt_showupstream
        #set -g __fish_git_prompt_showupstream informative
    #end
    #if not set -q __fish_git_prompt_char_upstream_ahead
        #set -g __fish_git_prompt_char_upstream_ahead "↑"
    #end
    #if not set -q __fish_git_prompt_char_upstream_behind
        #set -g __fish_git_prompt_char_upstream_behind "↓"
    #end
    #if not set -q __fish_git_prompt_char_upstream_prefix
        #set -g __fish_git_prompt_char_upstream_prefix ""
    #end
    #if not set -q __fish_git_prompt_char_stagedstate
        #set -g __fish_git_prompt_char_stagedstate "●"
    #end
    #if not set -q __fish_git_prompt_char_dirtystate
        #set -g __fish_git_prompt_char_dirtystate "✚"
    #end
    #if not set -q __fish_git_prompt_char_untrackedfiles
        #set -g __fish_git_prompt_char_untrackedfiles "…"
    #end
    #if not set -q __fish_git_prompt_char_invalidstate
        #set -g __fish_git_prompt_char_invalidstate "✖"
    #end
    #if not set -q __fish_git_prompt_char_cleanstate
        #set -g __fish_git_prompt_char_cleanstate "✔"
    #end
    #if not set -q __fish_git_prompt_color_dirtystate
        #set -g __fish_git_prompt_color_dirtystate blue
    #end
    #if not set -q __fish_git_prompt_color_stagedstate
        #set -g __fish_git_prompt_color_stagedstate yellow
    #end
    #if not set -q __fish_git_prompt_color_invalidstate
        #set -g __fish_git_prompt_color_invalidstate red
    #end
    #if not set -q __fish_git_prompt_color_untrackedfiles
        #set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    #end
    #if not set -q __fish_git_prompt_color_cleanstate
        #set -g __fish_git_prompt_color_cleanstate green --bold
    #end
#
    #set -l color_cwd
    #set -l suffix
    #if functions -q fish_is_root_user; and fish_is_root_user
        #if set -q fish_color_cwd_root
            #set color_cwd $fish_color_cwd_root
        #else
            #set color_cwd $fish_color_cwd
        #end
        #set suffix '#'
    #else
        #set color_cwd $fish_color_cwd
        #set suffix '$'
    #end
#
    ## PWD
    #set_color $color_cwd
    #echo -n (prompt_pwd)
    #set_color normal
#
    #printf '%s ' (fish_vcs_prompt)
#
    #set -l pipestatus_string (__fish_print_pipestatus "[" "] " "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
    #echo -n $pipestatus_string
    #set_color normal
#
    #echo -n "$suffix "
#end

### Tomita (https://github.com/daveyarwood/tomita)
#function fish_prompt
  #set -l tomita_vi_mode "$TOMITA_VI"
	#echo
#
	#set_color $fish_color_cwd
  #printf '%s' (prompt_pwd)
#
  #set_color normal
  #printf '%s ' (__fish_git_prompt)
#
  #if test -z (string match -ri '^no|false|0$' $tomita_vi_mode)
    #printf '['
    #switch $fish_bind_mode
      #case default
        #set_color --bold red
        #printf 'n'
      #case insert
        #set_color --bold green
        #printf 'i'
      #case visual
        #set_color --bold magenta
        #printf 'v'
    #end
    #set_color normal
    #printf '] '
  #end
#
  #set_color -o yellow
  #printf '⋊> '
  #set_color normal
#end

### Sashimi (https://github.com/isacikgoz/sashimi)
function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -g red (set_color -o red)
  set -g blue (set_color -o blue)
  set -l green (set_color -o green)
  set -g normal (set_color normal)

  set -l ahead (_git_ahead)
  set -g whitespace ' '

  if test $last_status = 0
    set initial_indicator "$green◆"
    set status_indicator "$normal❯$cyan❯$green❯"
  else
    set initial_indicator "$red✖ $last_status"
    set status_indicator "$red❯$red❯$red❯"
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'master'
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($red$git_branch$normal)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
end

function _git_ahead
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null)
  if [ $status != 0 ]
    return
  end
  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
  set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
  switch "$ahead $behind"
    case ''     # no upstream
    case '0 0'  # equal to upstream
      return
    case '* 0'  # ahead of upstream
      echo "$blue↑$normal_c$ahead$whitespace"
    case '0 *'  # behind upstream
      echo "$red↓$normal_c$behind$whitespace"
    case '*'    # diverged from upstream
      echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end
