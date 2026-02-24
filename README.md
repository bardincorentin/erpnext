
<div align="center">
    <a href="https://frappe.io/erpnext">
	<img src="./erpnext/public/images/v16/erpnext.svg" alt="Logo ERPNext" height="80px" width="80xp"/>
    </a>
    <h2>ERPNext</h2>
    <p align="center">
        <p>Logiciel ERP puissant, intuitif et open source</p>
    </p>

[![Apprendre sur Frappe School](https://img.shields.io/badge/Frappe%20School-Apprendre%20ERPNext-blue?style=flat-square)](https://frappe.school)<br><br>
[![CI](https://github.com/frappe/erpnext/actions/workflows/server-tests-mariadb.yml/badge.svg?event=schedule)](https://github.com/frappe/erpnext/actions/workflows/server-tests-mariadb.yml)
[![docker pulls](https://img.shields.io/docker/pulls/frappe/erpnext-worker.svg)](https://hub.docker.com/r/frappe/erpnext-worker)

</div>

<div align="center">
	<img src="./erpnext/public/images/v16/hero_image.png"/>
</div>

<div align="center">
	<a href="https://erpnext-demo.frappe.cloud/api/method/erpnext_demo.erpnext_demo.auth.login_demo">Démo en ligne</a>
	-
	<a href="https://frappe.io/erpnext">Site web</a>
	-
	<a href="https://docs.frappe.io/erpnext/">Documentation</a>
</div>

## ERPNext

Système ERP 100 % open source pour vous aider à gérer votre entreprise.

### Motivation

Gérer une entreprise est une tâche complexe : traiter les factures, suivre les stocks, gérer le personnel et bien d'autres activités ponctuelles. Dans un marché où les logiciels sont vendus séparément pour gérer chacune de ces tâches, ERPNext fait tout cela et plus encore, gratuitement.

### Fonctionnalités clés

- **Comptabilité** : Tous les outils nécessaires pour gérer vos flux de trésorerie en un seul endroit, de l'enregistrement des transactions à la synthèse et à l'analyse des rapports financiers.
- **Gestion des commandes** : Suivez les niveaux de stock, réapprovisionnez les stocks et gérez les commandes de vente, les clients, les fournisseurs, les expéditions, les livrables et l'exécution des commandes.
- **Production** : Simplifie le cycle de production, aide à suivre la consommation de matières, présente la planification des capacités, gère la sous-traitance et plus encore !
- **Gestion des actifs** : De l'achat à la mise au rebut, de l'infrastructure informatique aux équipements. Couvrez chaque branche de votre organisation dans un système centralisé unique.
- **Projets** : Livrez les projets internes et externes dans les délais, le budget et la rentabilité. Suivez les tâches, les feuilles de temps et les problèmes par projet.

<details open>

<summary>En savoir plus</summary>
	<img src="https://erpnext.com/files/v16_bom.png"/>
	<img src="https://erpnext.com/files/v16_stock_summary.png"/>
	<img src="https://erpnext.com/files/v16_job_card.png"/>
	<img src="https://erpnext.com/files/v16_tasks.png"/>
</details>

### Sous le capot

- [**Frappe Framework**](https://github.com/frappe/frappe) : Un framework d'application web full-stack écrit en Python et Javascript. Le framework fournit une base solide pour créer des applications web, incluant une couche d'abstraction de base de données, l'authentification des utilisateurs et une API REST.

- [**Frappe UI**](https://github.com/frappe/frappe-ui) : Une bibliothèque d'interface utilisateur basée sur Vue pour fournir une interface utilisateur moderne. La bibliothèque Frappe UI offre une variété de composants pouvant être utilisés pour créer des applications monopages sur le Frappe Framework.

## Installation en production

### Hébergement géré

Vous pouvez essayer [Frappe Cloud](https://frappecloud.com), une plateforme [open source](https://github.com/frappe/press) simple, conviviale et sophistiquée pour héberger des applications Frappe en toute sérénité.

Elle prend en charge l'installation, la configuration, les mises à jour, la surveillance, la maintenance et le support de vos déploiements Frappe. C'est une plateforme développeur complète avec la capacité de gérer et de contrôler plusieurs déploiements Frappe.

<div>
	<a href="https://erpnext-demo.frappe.cloud/app/home" target="_blank">
		<picture>
			<source media="(prefers-color-scheme: dark)" srcset="https://frappe.io/files/try-on-fc-white.png">
			<img src="https://frappe.io/files/try-on-fc-black.png" alt="Essayer sur Frappe Cloud" height="28" />
		</picture>
	</a>
</div>



### Auto-hébergement
#### Docker

Prérequis : docker, docker-compose, git. Consultez la [Documentation Docker](https://docs.docker.com) pour plus de détails sur la configuration Docker.

Exécutez les commandes suivantes :

```
git clone https://github.com/frappe/frappe_docker
cd frappe_docker
docker compose -f pwd.yml up -d
```

Après quelques minutes, le site devrait être accessible sur votre localhost au port 8080. Utilisez les identifiants de connexion par défaut ci-dessous pour accéder au site.
- Identifiant : Administrator
- Mot de passe : admin

Consultez [Frappe Docker](https://github.com/frappe/frappe_docker?tab=readme-ov-file#to-run-on-arm64-architecture-follow-this-instructions) pour la configuration Docker sur architecture ARM.


## Configuration pour le développement
### Installation manuelle

La méthode facile : notre script d'installation pour bench installera toutes les dépendances (ex. MariaDB). Voir https://github.com/frappe/bench pour plus de détails.

De nouveaux mots de passe seront créés pour l'utilisateur ERPNext "Administrator", l'utilisateur root MariaDB et l'utilisateur frappe (le script affiche les mots de passe et les enregistre dans ~/frappe_passwords.txt).


### En local

Pour configurer le dépôt localement, suivez les étapes ci-dessous :

1. Configurez bench en suivant les [Étapes d'installation](https://frappeframework.com/docs/user/en/installation) et démarrez le serveur
   ```
   bench start
   ```

2. Dans une fenêtre de terminal séparée, exécutez les commandes suivantes :
   ```
   # Créer un nouveau site
   bench new-site erpnext.localhost
   ```

3. Récupérer l'application ERPNext et l'installer
   ```
   # Récupérer l'application ERPNext
   bench get-app https://github.com/frappe/erpnext

   # Installer l'application
   bench --site erpnext.localhost install-app erpnext
   ```

4. Ouvrez l'URL `http://erpnext.localhost:8000/app` dans votre navigateur, vous devriez voir l'application en cours d'exécution

## Apprentissage et communauté

1. [Frappe School](https://school.frappe.io) - Apprenez le Frappe Framework et ERPNext grâce aux différents cours des mainteneurs ou de la communauté.
2. [Documentation officielle](https://docs.erpnext.com/) - Documentation exhaustive pour ERPNext.
3. [Forum de discussion](https://discuss.frappe.io/c/erpnext/6) - Échangez avec la communauté des utilisateurs et prestataires de services ERPNext.
4. [Groupe Telegram](https://erpnext_public.t.me) - Obtenez une aide instantanée d'une grande communauté d'utilisateurs.


## Contribution

1. [Directives pour les issues](https://github.com/frappe/erpnext/wiki/Issue-Guidelines)
1. [Signaler des vulnérabilités de sécurité](https://erpnext.com/security)
1. [Exigences pour les pull requests](https://github.com/frappe/erpnext/wiki/Contribution-Guidelines)
2. [Traductions](https://crowdin.com/project/frappe)


## Politique sur le logo et les marques déposées

Veuillez lire notre [Politique sur le logo et les marques déposées](TRADEMARK_POLICY.md).

<br />
<br />
<div align="center" style="padding-top: 0.75rem;">
	<a href="https://frappe.io" target="_blank">
		<picture>
			<source media="(prefers-color-scheme: dark)" srcset="https://frappe.io/files/Frappe-white.png">
			<img src="https://frappe.io/files/Frappe-black.png" alt="Frappe Technologies" height="28"/>
		</picture>
	</a>
</div>
