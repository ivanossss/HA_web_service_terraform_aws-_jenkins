## Hello everyone!

This is my project to deploy a highly available cluster of web servers using AWS-based terraforms. Also, a prometheus instance is deployed for the cluster, which starts collecting metrics from all web servers, and a grafana instance, which starts collecting metrics from prometheus. **With the help of scripts and other tricks, the instances are configured to receive new ips, and not hardcoded, which means that after setting up, destroying and rebuilding the infrastructure - everything will work as before**. And the last element - jenkins, is also deployed already configured and ready to go.

### Used software stack:
1. terraform
2. aws
3. prometheus+grafana
4. jenkins
5. docker (uses jenkins in its pipeline)

P.S. The main settings and what you have to change are stored in thematic folders (monitoring, jenkins ...) The bottom line is that you first make the settings you want, then download the configuration files to your server from which you launch terraform, re-deployment will occur the reverse process. Good luck!

---

## Всем привет!

Это мой проект по разворачиванию высокодоступного кластера веб-серверов с помощью терраформ на базе AWS, так же для кластера разворачивается инстанс prometheus, который начинаем собирать метрики со всех веб-серверов, и инстанс grafana, который начинает собирать метрики с prometheus. **С помощью скриптов и прочих хитростей инстансы настроены на получение новых ip , а не вбиты хардкодом, это значит что после настройки, уничтожение и поднятия заново инфраструктуры - все будет работать как раньше**. И последний элемент - jenkins, так же разворачивается уже настроенным и готовым к работе.

### Используемы программный стек:
1. terraform
2. aws
3. prometheus+grafana
4. jenkins
5. docker (использует дженкинс в piplines)

P.S. Основные настройки и то что вам придется поменять храняться с тематических папках (monitoring, jenkins...) Суть в том , что вы в начале сделаете настройку , которую хотите, затем выкачаете конфигурационные файлы к себе на сервер, из которого запускаете терраформ , а при повторном разворачивании будет происходить обратный процесс. Удачи!

