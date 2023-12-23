import pandas as pd

parquet = pd.read_parquet('data0.parquet')

# FORMATTING OF data0
#         timestamp     src_ip              dst_ip              proto        port    up_bytes    down_bytes
# index                                                                                   
# 781135    1324136     192.168.100.155     192.168.100.224     udp             53          261         526
# 781136    1324141     192.168.100.155     192.168.100.224     udp             53          209         496
# 781137    1324147     192.168.100.155     192.168.100.224     udp             53          208         496
# ...

normal_user_flows = "normal_flows/"

#get statistics
#Number of UDP flows for each source IP
n_flows_udp=parquet.loc[parquet['proto']=='udp'].groupby(['src_ip'])['up_bytes'].count()

#Number of TCP flows for each source IP
n_flows_tcp=parquet.loc[parquet['proto']=='tcp'].groupby(['src_ip'])['up_bytes'].count()

# List of all source IPs
src_ip_flows=parquet.groupby(['src_ip'])['up_bytes'].count()

# src_ips statistics
# udp_flows, udp_up_bytes, average up_bytes per flow, udp_down_bytes, average down_bytes per flow, udp ports, dest_ips
# tcp_flows, tcp_up_bytes, average up_bytes per flow, tcp_down_bytes, average down_bytes per flow, tcp ports, dest_ips
for key in parquet['src_ip'].unique(): #np.sort(parquet['src_ip'].unique()):
    print("\nSRC_IP: " + str(key))

    print("UDP")
    print("flows: " + str(len(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')])))
    print("sum(up_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['up_bytes'].sum()))
    print("mean(up_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['up_bytes'].mean()))
    print("sum(down_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['down_bytes'].sum()))
    print("mean(down_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['down_bytes'].mean()))
    print("used ports: " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['port'].unique()))
    print("dest_ips: " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='udp')]['dst_ip'].unique()))
    print("")

    print("TCP")
    print("flows: " + str(len(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')])))
    print("sum(up_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['up_bytes'].sum()))
    print("mean(up_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['up_bytes'].mean()))
    print("sum(down_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['down_bytes'].sum()))
    print("mean(down_bytes): " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['down_bytes'].mean()))
    print("used ports: " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['port'].unique()))
    print("dest_ips: " + str(parquet.loc[(parquet['src_ip']==key) & (parquet['proto']=='tcp')]['dst_ip'].unique()))
    print("")

    print("TEMPORAL BEHAVIOUR")
    print("STARTED AT: " + str(parquet.loc[(parquet['src_ip']==key)]['timestamp'].min()))
    print("ENDED AT: " + str(parquet.loc[(parquet['src_ip']==key)]['timestamp'].max()))
    print("--------------------------------------------------------------------")


#write flows with different src_ip in different files
# for src in src_ip:
#     #open file
#     file = open(normal_user_flows+src + ".txt", "w")
#     #write header
#     file.write("src_ip,dst_ip,proto,port,occurrences,up_bytes,down_bytes\n")
#     #write flows
#     for key in flows.keys():
#         if key[0] == src:
#             #write all in string
#             file.write(str(key[0]) + "," + str(key[1]) + "," + str(key[2]) + "," + str(key[3]) + "," + str(flows[key][0]) + "," + str(flows[key][1]) + "," + str(flows[key][2]) + "\n")

#     file.close()
