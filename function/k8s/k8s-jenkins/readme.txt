执行说明
kubectl apply -f jenkins.yml
kubectl apply -f service-account.yml
[root@k8s-master01 kubernetes]# kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                          AGE
jenkins      NodePort    10.99.70.163   <none>        8080:32414/TCP,50000:32437/TCP   66m
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP                          47h
[root@k8s-master01 kubernetes]# kubectl get pod
NAME                            READY   STATUS    RESTARTS   AGE
jenkins-0                       1/1     Running   4          63m
myapp-deploy-6968c6cc7f-jgxhv   1/1     Running   3          46h
myapp-deploy-6968c6cc7f-qn4df   1/1     Running   4          46h
myapp-deploy-6968c6cc7f-zqhjk   1/1     Running   3          46h
[root@k8s-master01 kubernetes]# kubectl get serviceaccount
NAME      SECRETS   AGE
default   1         47h
jenkins   1         65m
[root@k8s-master01 kubernetes]# 

