#!/usr/bin/env python

"""Custom topology example
Adding the 'topos' dict with a key/value pair to generate our newly defined
topology enables one to pass in '--topo=mytopo' from the command line.
"""
from mininet.net import Mininet
from mininet.node import Node
from mininet.link import TCLink
from mininet.log import  setLogLevel, info
from threading import Timer
from mininet.util import quietRun, ipAdd
from time import sleep
from mininet.cli import CLI
from mininet.topo import Topo

class CustomTopo( Topo ):

    def build( self, count=1,ipstart=0x0a010000, br='br-int', brdp="0000abcdef000001" ):
        if isinstance(ipstart, str): ipstart=int(ipstart,16)
        customBr = self.addSwitch( str(br), dpid=str(brdp) )
        hosts = [ self.addHost( 'h%d' % i, ip= ipAdd(i,16,ipstart)+'/8') for i in range( 1, count + 1 ) ]
        # Add links
        for h in hosts:                                                                                                       
            self.addLink( h, customBr)

topos = { 'custom': CustomTopo }

def myNet():

    Mininet.init()
    info( "*** Creating nodes\n" )
    net = Mininet( topo=CustomTopo(3))
    net.start()
    CLI(net)
    net.stop()

if __name__ == '__main__':

    setLogLevel( 'info' )
    myNet()


