#!/usr/bin/env python

"""
gcd computing node

author:  Damian Weber (dweber at htw-saarland.de)
date:    Wed Jan  9 21:46:30 CET 2013
license: see file LICENSE

setup:
random graph with fixed number of neighbours per node
(2 for small graphs, 5 for graphs with >=10 nodes)

message types:
- APPL = gcd computation
- SYST = system commands (KILL, initiation APPL/ECHO)
- MSGC/MSGR = message count / message count reply for termination detection

concept of main loop:
- Listen 
- Receive 
- Handle(incoming_message) 
- Send(Recipient Set,outgoing_message)
"""

# -------------------------------------------------------------
import socket
import sys
import time
import random
import re
import datetime
# -------------------------------------------------------------

# port is PORT_BASE+id
global PORT_BASE
# maximal value for random numbers
global MAX_VALUE

# -------------------------------------------------------------

# the state of a node
class nodedata:
	def __init__(self,ident,value,number_of_nodes):
		self.ident=ident
		self.value=value
		self.port=PORT_BASE+ident
		self.number_of_nodes=number_of_nodes;
		self.neighbours=[];

		self.echo_initiator=False;
		self.gcd_initiator=False;

		self.received=0;
		self.sent=0;

		self.sum_received=0;
		self.sum_sent=0;
		self.sum_received_backup=0;
		self.sum_sent_backup=0;
		self.msgr_count=0;
		self.msgr_busy=False;
		self.terminate=False;

# -------------------------------------------------------------
# extract a single integer from a (message) string
#
def extract_number(message):
	regex=re.compile('[0-9][0-9]*'); # find number
	regex_match=regex.search(message);
	if regex_match:
		number = int(regex_match.group())
	else:
		number=0
	return number;
# -------------------------------------------------------------
# extract an integer pair from a (message) string
# if more than 2 integers are available, it picks the
# first and the last
#
def extract_number_pair(message):
	regex=re.compile('[0-9][0-9]*'); # find numbers
	number_set=regex.findall(message)
	i=0
	for n in number_set:
		i=i+1
		if i==1:
			x=int(n)
		else:
			y=int(n)
	if i==1:
		y=0
	
	if i==0:
		x=0
	
	return x,y
# -------------------------------------------------------------
# produces a logging row header containing current timestamp and id like
# 09.01.2013 09:20:37 CET [2] 
def timeheader(ident):
	timestamp=time.strftime('%d.%m.%Y %X %Z')
	return timestamp+" ["+str(ident)+"]";

# -------------------------------------------------------------
# make server operational at port
def create_server_socket(port):
	backlog = 80
	server_listen_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server_listen_socket.bind((host,port))
	server_listen_socket.listen(backlog)
	return server_listen_socket;

# -------------------------------------------------------------
# create list of random nodes, no duplicates, not own id
# useful for neighbour list
def random_list(number_of_nodes,ident,number_items):
	a=[];
	i=0;
	while i<number_items:
		r=random.randint(1,number_of_nodes)
		if r!=ident and (not r in a):
			a.append(r);
			i=i+1
	return a

# -------------------------------------------------------------
# creates list without a specific element
def list_without(list,element):
	a=[]
	for x in list:
		if x!=element:
			a.append(x);
	return a

# -------------------------------------------------------------
# incoming messages of type SYST are handled here
def handle_system_message(node,sender_address, incoming_message):
	if incoming_message[5:9]=="APPL":
		node.gcd_initiator=True;
		return node.neighbours, "APPL "+str(node.value)
	if incoming_message[5:9]=="ECHO":
		node.echo_initiator=True;
		return node.neighbours, "ECHO EXPLORER "+str(node.ident)
	if incoming_message[5:9]=="KILL":
		print timeheader(node.ident),"propagate KILL to neighbour set",node.neighbours
		return node.neighbours, "SYST KILL "+str(node.ident)
	return None,"ERROR"

# -------------------------------------------------------------
# incoming messages of unknown type are handled here
def handle_unknown_message(node,sender_address, incoming_message):
	return None, "ERROR "+incoming_message

# -------------------------------------------------------------
# incoming messages of type MSGC are handled here
def handle_message_count_message(node,sender_address, incoming_message):

	sender_ident=extract_number(incoming_message)
	list=[]
	list.append(sender_ident);
	return list, "MSGR "+str(node.sent)+" "+str(node.received);

# -------------------------------------------------------------
# incoming messages of type MSGR are handled here

def handle_message_result_message(node,sender_address, incoming_message):
	(s,r)=extract_number_pair(incoming_message)
	node.sum_sent=node.sum_sent+s
	node.sum_received=node.sum_received+r
	node.msgr_count=node.msgr_count+1
	if node.msgr_count==node.number_of_nodes-1:
		node.sum_sent=node.sum_sent+node.sent
		node.sum_received=node.sum_received+node.received
		print timeheader(node.ident),"termination check, S=",node.sum_sent,"R=",node.sum_received
		if node.sum_sent!=node.sum_received:
			print timeheader(node.ident),"no termination yet, starting recount"
			send_msgc_request(node);
		else:
			if node.sum_sent==node.sum_sent_backup and node.sum_received==node.sum_received_backup:
				print timeheader(node.ident),"TERMINATION detected"
				print timeheader(node.ident),"GCD computed:",node.value
				node.terminate=True;
			else:
				print timeheader(node.ident),"termination suspected, starting recount"
				node.sum_sent_backup=node.sum_sent
				node.sum_received_backup=node.sum_received
				send_msgc_request(node);
	return None,"";


# -------------------------------------------------------------
# incoming messages of type ECHO are handled here
def handle_echo_message(node,sender_address,incoming_message):
	# do we already have a parent?
	if not hasattr(handle_echo_message, "count_incoming"):
		handle_echo_message.count_incoming=0;


	handle_echo_message.count_incoming=handle_echo_message.count_incoming+1
	count_incoming=handle_echo_message.count_incoming;


	print "# count incoming ",node.port,count_incoming,len(node.neighbours), node.echo_initiator

	if count_incoming == 1 and node.echo_initiator==False:
		handle_echo_message.parent=extract_number(incoming_message)
		parent=handle_echo_message.parent
		print "# parent",node.port,parent
		return list_without(node.neighbours,parent),"ECHO EXPLORER "+str(node.ident)

	if count_incoming == len(node.neighbours):
		handle_echo_message.count_incoming=0
		if node.echo_initiator==False:
			parent=handle_echo_message.parent
			handle_echo_message.parent==0;
			outgoing_message="ECHO ECHO "+str(node.ident)
			print "#",node.ident,outgoing_message,"to",parent;
			recipients=[]
			recipients.append(parent)
			return recipients,"ECHO ECHO "+str(node.ident)
	return [],"";

# -------------------------------------------------------------
# incoming messages of type APPL (i.e. gcd computation) are handled here
def handle_application_message(node,sender_address, incoming_message):

	ident=node.ident

	x=extract_number(incoming_message)
	value=node.value;

	if x==0 or x==value:
		print timeheader(ident),"do nothing, value=",value,"x=",x
		return [],""

	if x>value:
		print timeheader(ident),"reduce value=",value,"x=",x,"to value=",x % value
		value=x % value
		if value!=0:
			node.value=value
			return node.neighbours,"APPL "+str(value);
		else:
			print timeheader(ident),"keep value=",node.value
			return [],"";

	if x>0 and x<value:
		print timeheader(ident),"reduce value=",value,"x=",x,"to value=",value % x
		value = value % x
		if value!=0:
			node.value=value
			return node.neighbours,"APPL "+str(value);
		else:
			print timeheader(ident),"restore value=",x
			node.value=x
			return [],"";

# -------------------------------------------------------------
# generic handle message function, determines type and calls correct handler
def handle(node, sender_address, incoming_message):
	if incoming_message[0:4]=="SYST":
		return handle_system_message(node,sender_address, incoming_message)
	if incoming_message[0:4]=="ECHO":
		return handle_echo_message(node,sender_address, incoming_message)
	if incoming_message[0:4]=="APPL":
		return handle_application_message(node,sender_address, incoming_message)
	if incoming_message[0:4]=="MSGC":
		return handle_message_count_message(node,sender_address, incoming_message)
	if incoming_message[0:4]=="MSGR":
		return handle_message_result_message(node,sender_address, incoming_message)
	return handle_unknown_message(node,sender_address, incoming_message);

# -------------------------------------------------------------
# generic message receive function
def receive_message(connection,node):
	MAX_MESSAGE_LENGTH = 1024

	ident=node.ident
	incoming_message=connection.recv(MAX_MESSAGE_LENGTH)

        #TIME MEASURE
        print timeheader(ident),"RECV",incoming_message
        time_string = " TIME "
        time_pos = incoming_message.find(time_string)
        if time_pos > -1:
            current_time = datetime.datetime.now().strftime('%s.%f')
            msg_time = incoming_message[time_pos + len(time_string):]
            incoming_message = incoming_message[:time_pos]
            diff = float(current_time) - float(msg_time)
            print "TIME MEASURE:", diff


	connection.close() 
	print timeheader(ident),"RECV",incoming_message

	if incoming_message[0:4]=="APPL":
		node.received=node.received+1
	return (sender_address,incoming_message)
# -------------------------------------------------------------
# generic message send function, sends outgoing_message to ident nb
def send_to(node,nb,outgoing_message):
	node_address = ('localhost', PORT_BASE+nb)
	ident=node.ident

        outgoing_message += " TIME " + datetime.datetime.now().strftime('%s.%f')

	print timeheader(ident),"SEND to",node_address,outgoing_message
	client_connect_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	try:
		client_connect_socket.connect(node_address)
	except socket.error as msg:
		print timeheader(ident),msg
		print timeheader(ident),"terminating due to missing node"
		sys.exit(0)

	client_connect_socket.send(outgoing_message)
	client_connect_socket.close()
#	time.sleep(0.05) # 50 ms delay
	if outgoing_message[0:4]=="APPL":
		node.sent=node.sent+1

# -------------------------------------------------------------
# send kill request to all other nodes
def send_kill_request(node):
	for nb in range(1,node.number_of_nodes+1):
		if nb!=node.ident:
			send_to(node,nb,"SYST KILL "+str(node.ident));

# -------------------------------------------------------------
# send message count request to all other nodes

def send_msgc_request(node):
	node.sum_sent=0;
	node.sum_received=0;
	node.msgr_count=0;
	node.msgr_busy=True;
	for nb in range(1,node.number_of_nodes+1):
		if nb!=node.ident:
			send_to(node,nb,"MSGC "+str(node.ident));

# ----------------------- ---- --------------------------------
# ----------------------- main --------------------------------
# ----------------------- ---- --------------------------------

# compute gcd by Euclidean algorithm, distributed version

if len(sys.argv) <= 2:
	print "usage:",sys.argv[0]," <number_of_nodes> <ident>";
	exit(1)

PORT_BASE=50000
MAX_VALUE=20000

# default host name
host = ''

# read number of nodes and own identity from command line
number_of_nodes=int(sys.argv[1])
ident=int(sys.argv[2])

# set number of random neighbour nodes
if number_of_nodes < 10:
	NUMBER_OF_NEIGHBOURS=2
else:
	NUMBER_OF_NEIGHBOURS=5

# sanity check of identity 
if ident<1 or ident>number_of_nodes:
	print "wrong identity",ident,"must be >=1 and <=",number_of_nodes
	exit(1)

# set random value
value=4*random.randint(1,MAX_VALUE); # gcd at least 4

# logging the start
print timeheader(ident),"START, random value =",value;

# initialize state
node=nodedata(ident,value,number_of_nodes)
# create neighbour list
node.neighbours=random_list(number_of_nodes,node.ident,NUMBER_OF_NEIGHBOURS)
print timeheader(ident),"neighbour list",node.neighbours


# set up server
server_listen_socket = create_server_socket(node.port);

# run until termination condition
running=True;
while running:
# LISTEN
	(connection,sender_address) = server_listen_socket.accept()
# RECEIVE
	(sender_address,incoming_message) = receive_message(connection,node);
# HANDLE
	(recipients,outgoing_message)=handle(node, sender_address, incoming_message)
# SEND to recipients
	if recipients != None:
		for nb in recipients:
			send_to(node,nb,outgoing_message);
# an application message that does not need to be answered
# could be the sign of termination of the whole computation
# so we start counting send/receive messages
		if len(recipients)==0 and incoming_message[0:4]=="APPL" and node.msgr_busy==False:
			send_msgc_request(node);

# if we should terminate, we terminate all others
	if node.terminate==True:
		send_kill_request(node);
		running=False

# leave while loop after sending KILL
	if outgoing_message[0:9] == "SYST KILL":
		running=False;

# final log message
print timeheader(ident),"terminating"

exit(0);
