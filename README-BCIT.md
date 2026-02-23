# ERPNext — Installation Docker BCIT Formation

> **BCIT Formation** · Cybersécurité : Conseil, Audit & Formation
> 33 rue des Charmes, 16110 PRANZAC · [www.bcit.fr](https://www.bcit.fr)

Ce dossier contient les fichiers nécessaires pour installer ERPNext v15 en local via Docker, préconfiguré pour BCIT Formation (France, EUR, français).

---

## Prérequis

| Outil | Version minimale |
|-------|-----------------|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | 24+ |
| Docker Compose (inclus dans Docker Desktop) | v2+ |

> **macOS / Windows** : Docker Desktop suffit.
> **Linux** : installez `docker` + le plugin `docker-compose-plugin`.

---

## Installation rapide

```bash
# 1. Décompresser le dossier BCIT ERPNext et s'y rendre
cd ~/Downloads/ERPNEXT

# 2. Rendre le script exécutable (une seule fois)
chmod +x setup.sh

# 3. (Optionnel) Personnaliser les mots de passe dans .env
nano .env

# 4. Lancer l'installation (~5 minutes)
./setup.sh
```

À la fin, ERPNext est accessible sur **http://localhost:8080**.

| Champ | Valeur |
|-------|--------|
| Identifiant | `Administrator` |
| Mot de passe | voir `ADMIN_PASSWORD` dans `.env` (défaut : `BcitAdmin2024!`) |

---

## Structure des fichiers

```
ERPNEXT/
├── setup.sh          # Script d'installation automatique
├── docker-compose.yml # Définition de tous les services Docker
└── .env              # Variables de configuration (mots de passe, site, société)
```

---

## Configuration (.env)

Éditez `.env` avant l'installation pour adapter à votre environnement :

```dotenv
# Nom du site ERPNext (ne pas changer après installation)
SITE_NAME=bcit.localhost

# Mots de passe — À MODIFIER avant mise en production !
MYSQL_ROOT_PASSWORD=BcitDB2024!
ADMIN_PASSWORD=BcitAdmin2024!

# Port d'accès (défaut : 8080)
PORT=8080

# Informations société
COMPANY_NAME="BCIT Formation"
COMPANY_ABBR="BCIT"
COUNTRY="France"
CURRENCY="EUR"
LANGUAGE="fr"
TIMEZONE="Europe/Paris"
```

> **Important** : les valeurs contenant des espaces doivent être entourées de guillemets doubles.

---

## Services Docker

| Service | Rôle |
|---------|------|
| `db` | Base de données MariaDB 10.6 |
| `redis` | Cache et file de messages |
| `backend` | Serveur applicatif ERPNext |
| `websocket` | Notifications temps réel (Socket.IO) |
| `file-attente` | Traitement des tâches asynchrones (emails, rapports…) |
| `planificateur` | Tâches planifiées (cron ERPNext) |
| `frontend` | Interface web Nginx (port 8080) |

---

## Commandes utiles

```bash
# Arrêter ERPNext
docker compose down

# Redémarrer ERPNext
docker compose restart

# Afficher les logs en temps réel
docker compose logs -f

# Mettre à jour ERPNext
docker compose pull && docker compose up -d

# Accéder au shell ERPNext (bench)
docker compose exec backend bash
```

---

## Premières étapes dans ERPNext

Après connexion sur http://localhost:8080 :

1. **Paramétrage de la société** → Comptabilité → Plan comptable français (PCG)
2. **Création des utilisateurs** → Paramètres → Utilisateurs
3. **Configuration de la TVA** → Comptabilité → Modèles de taxes
4. **Import des données** → Outils → Import de données

---

## Réinstallation complète

Pour repartir de zéro (⚠ supprime toutes les données) :

```bash
docker compose down -v   # supprime les volumes
./setup.sh               # réinstalle depuis zéro
```

---

## Support

- Site : [www.bcit.fr](https://www.bcit.fr)
- Documentation ERPNext : [docs.frappe.io/erpnext](https://docs.frappe.io/erpnext)
- Forum ERPNext : [discuss.frappe.io](https://discuss.frappe.io)
