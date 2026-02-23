#!/bin/bash
# ============================================================
# BCIT Formation - Script d'installation ERPNext
# Cybersécurité : Conseil, Audit & Formation
# 33 rue des Charmes, 16110 PRANZAC | www.bcit.fr
# ============================================================

set -e

VERT='\033[0;32m'
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
RESET='\033[0m'

ok()   { echo -e "${VERT}✓ $1${RESET}"; }
info() { echo -e "${JAUNE}→ $1${RESET}"; }
err()  { echo -e "${ROUGE}✗ $1${RESET}"; exit 1; }

echo ""
echo "============================================================"
echo "  BCIT Formation - Installation ERPNext"
echo "  Cybersécurité : Conseil, Audit & Formation"
echo "  www.bcit.fr"
echo "============================================================"
echo ""

# Vérifier que Docker est installé
command -v docker >/dev/null 2>&1 || err "Docker n'est pas installé. Installez Docker puis relancez ce script."
command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 || err "Docker Compose n'est pas disponible."

# Charger les variables d'environnement
[ -f .env ] || err "Fichier .env introuvable. Copiez .env.exemple en .env et configurez-le."
source .env

ok "Docker détecté"
info "Site : $SITE_NAME | Société : $COMPANY_NAME"
echo ""

# Étape 1 : Démarrer la base de données et Redis
info "Démarrage de la base de données et du cache..."
docker compose up -d db redis
echo ""

# Attendre que MariaDB soit prêt
info "Attente de la base de données (30 secondes max)..."
for i in $(seq 1 30); do
    docker compose exec db mysqladmin ping -h localhost --password="$MYSQL_ROOT_PASSWORD" --silent 2>/dev/null && break
    echo -n "."
    sleep 1
done
echo ""
ok "Base de données prête"

# Étape 2 : Configurer ERPNext
info "Configuration d'ERPNext..."
docker compose run --rm configurateur
ok "Configuration terminée"

# Étape 3 : Créer le site BCIT
info "Création du site $SITE_NAME (opération longue, ~5 minutes)..."
docker compose run --rm creation-site
ok "Site créé"

# Étape 4 : Démarrer tous les services
info "Démarrage de tous les services..."
docker compose up -d
ok "Tous les services démarrés"

echo ""
echo "============================================================"
echo "  Installation terminée !"
echo "============================================================"
echo ""
echo "  Accès : http://localhost:${PORT:-8080}"
echo "  Login : Administrator"
echo "  Mot de passe : $ADMIN_PASSWORD"
echo ""
echo "  Prochaines étapes dans ERPNext :"
echo "  1. Créer la société 'BCIT Formation'"
echo "  2. Configurer le plan comptable français"
echo "  3. Ajouter les utilisateurs"
echo ""

# Étape 5 : Créer la société via bench
info "Création de la société BCIT Formation..."
docker compose exec backend bench --site "$SITE_NAME" execute \
    frappe.client.insert \
    --args "{
        'doctype': 'Company',
        'company_name': '$COMPANY_NAME',
        'abbr': '$COMPANY_ABBR',
        'default_currency': '$CURRENCY',
        'country': '$COUNTRY',
        'phone_no': '',
        'website': 'www.bcit.fr',
        'address_line1': '33 rue des Charmes',
        'city': 'PRANZAC',
        'pincode': '16110'
    }" 2>/dev/null && ok "Société '$COMPANY_NAME' créée" || info "La société sera à créer manuellement dans ERPNext"

echo ""
echo "  Commandes utiles :"
echo "  Arrêter    : docker compose down"
echo "  Logs       : docker compose logs -f"
echo "  Redémarrer : docker compose restart"
echo "  Mise à jour: docker compose pull && docker compose up -d"
echo ""
