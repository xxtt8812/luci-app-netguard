#!/bin/sh
# 高级时间处理函数

is_time_active() {
    local current_epoch=$(date +%s)
    local start=$(date -d "${1%%-*}" +%s)
    local end=$(date -d "${1##*-}" +%s)
    
    [ $current_epoch -ge $start ] && [ $current_epoch -le $end ] && return 0
    return 1
}

check_schedule() {
    local schedule_name=$1
    local current_day=$(date +%a | tr 'A-Z' 'a-z')
    
    uci -q show netguard.@time_group | while read -r line; do
        local group=${line#*=}
        if [ "$group" = "$schedule_name" ]; then
            local days=$(uci get netguard.$group.days)
            if [[ "$days" =~ $current_day ]]; then
                for time_range in $(uci get netguard.$group.time_range); do
                    is_time_active $time_range && return 0
                done
            fi
        fi
    done
    return 1
}
