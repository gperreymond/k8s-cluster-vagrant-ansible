Installation de gitlab omnibus avec bitnami
Faire un apt update|upgrade pour avoir les dernières versions !

Credentials au départ => https://docs.bitnami.com/aws/faq/get-started/find-credentials/#option-2-find-password-by-connecting-to-your-application-through-ssh
Pour faire simple, aller voir les logs de l'instance EC2 gitlab, les credentials sont dedans, sinon, ssh sur l'instance, le fichier 
/home/bitnami/bitnami_credentials contient le login et le mot de passe root.

*** gitlab.rb ***
Ce fichier de configuration se trouve dans ce path : /etc/gitlab/gitlab.rb
Attention, ce fichier est protégé, vous devrait donc toujours passé par sudo pour le modifier
Cela est volontaire. Pour chaque modification, j'effectue en amont un backup de la configuration.
Pour se faire, je mv le fichier avec en suffixe .bkp.<id>. 

Chaque modification dans ce fichier devra être suivi de la commande 
sudo gitlab-ctl reconfigure
C'est alors que les changements seront pris en compte.
A noter que des erreurs remontent en cas de soucis de configuration.

Un fichier gitlab.rb est présent en local si besoin de reconfé rapidement.
Attention, ce fichier ne permet pas d'envoie de notification par email.

Modifier les variables suivantes :
external_url 'https://gitlab.xxxxxx.com'
Attention, cette variable va être changée à chaque reboot si vous avez
bootstraper avec bitnami omnibus, il faut donc supprimer le fichier suivant :
sudo rm /opt/bitnami/apps/gitlab/bnconfig
(on peut aussi faire un mv, ce que j'ai fait sur le serveur de production)

*** Configuration SSL ***
Théoriquement, avec des certificats SSL on doit modifier les variables suivantes :
nginx['enable'] = true
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/server.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/server.key"
Puis faire les commandes suivantes
chown root sur /etc/gitlab/ssl
chmod 600 sur /etc/gitlab/ssl
Pour enfin déplacer le fichier server.crt dans /etc/gitlab/ssl
puis déplacer le fichier server.key dans /etc/gitlab/ssl

Dans notre cas, n'ayant pas le certificat, je suis passé par letsencrypt:
letsencrypt['enable'] = true
letsencrypt['contact_emails'] = ['yyyyyy@xxxxxx.com']
letsencrypt['auto_renew'] = true
letsencrypt['auto_renew_hour'] = 0
letsencrypt['auto_renew_minute'] = 0 
letsencrypt['auto_renew_day_of_month'] = "*/7"

*** Configuration Google auth ***
Pour l'authentification via google auth :
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['google_oauth2']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_auto_link_ldap_user'] = false
gitlab_rails['omniauth_providers'] = [
  {
   "name" => "google_oauth2",
   "app_id" => "245685710459-tun04bouphcn6thoql2s4l9iauuakomi.apps.googleusercontent.com",
   "app_secret" => "d7ngJPx6hu05I9VkObErc56U",
   "args" => { "access_type" => "offline", "approval_prompt" => "" }
  }
]

Pour tester l'envoie des emails :
https://docs.gitlab.com/ee/administration/troubleshooting/debug.html

*** Suivi des logs ***
Vous pouvez aussi suivre les différents logs :
sudo cat /var/log/gitlab/gitlab-rails/production_json.log
sudo cat /var/log/gitlab/gitlab-rails/production.log 
sudo cat /var/log/gitlab/gitlab-rails/application.log 
D'autres logs sont disponibles, plus d'informations ici : 
https://docs.gitlab.com/ee/administration/logs.html

*** Suivi des status des services ***
On peut voir si les services sont disponibles avec la commande :
sudo gitlab-ctl status
un output possible : 
run: gitaly: (pid 536) 41s; run: log: (pid 533) 41s
run: gitlab-monitor: (pid 532) 41s; run: log: (pid 530) 41s
run: gitlab-workhorse: (pid 537) 41s; run: log: (pid 531) 41s
run: logrotate: (pid 524) 41s; run: log: (pid 522) 41s
run: nginx: (pid 539) 41s; run: log: (pid 535) 41s
run: node-exporter: (pid 551) 41s; run: log: (pid 550) 41s
run: postgres-exporter: (pid 527) 41s; run: log: (pid 525) 41s
run: postgresql: (pid 518) 41s; run: log: (pid 516) 41s
run: prometheus: (pid 538) 41s; run: log: (pid 534) 41s
run: redis: (pid 521) 41s; run: log: (pid 517) 41s
run: redis-exporter: (pid 548) 41s; run: log: (pid 546) 41s
run: sidekiq: (pid 529) 41s; run: log: (pid 528) 41s
run: unicorn: (pid 520) 41s; run: log: (pid 519) 41s

*** Configuration de l'application (admin pane sur gitlab directement) ***
Whitelisted domains for sign-up
Autoriser que les domaines xxxxxx.com et *.xxxxxx.com
Send confirmation email on sign-up
