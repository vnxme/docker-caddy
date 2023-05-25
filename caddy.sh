#!/bin/sh


if [ ! -z $IPV4_ADDRESS ] ; then
    /sbin/ip -4 addr flush dev eth0 scope global || true
    /sbin/ip -4 addr add $IPV4_ADDRESS dev eth0  || true
fi

if [ ! -z $IPV4_GATEWAY ] ; then
    /sbin/ip -4 route del default || true
    /sbin/ip -4 route add default via $IPV4_GATEWAY || true
fi


if [ ! -z $IPV6_ADDRESS ] ; then
    /sbin/ip -6 addr flush dev eth0 scope global || true
    /sbin/ip -6 addr add $IPV6_ADDRESS dev eth0  || true
fi

if [ ! -z $IPV6_GATEWAY ] ; then
    /sbin/ip -6 route del default || true
    /sbin/ip -6 route add default via $IPV6_GATEWAY || true
fi


exec /usr/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
