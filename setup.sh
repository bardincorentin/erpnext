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
docker compose version >/dev/null 2>&1 || err "Docker Compose n'est pas disponible."

# Charger le fichier .env (set -a exporte toutes les variables, gère les espaces)
[ -f .env ] || err "Fichier .env introuvable."
set -a; source .env; set +a

ok "Docker détecté"
info "Site : $SITE_NAME | Société : $COMPANY_NAME"
echo ""

# Étape 1 : Démarrer la base de données et Redis
info "Démarrage de la base de données et du cache..."
docker compose up -d db redis
echo ""

# Attendre que MariaDB soit prêt (sans set -e interférer)
info "Attente de la base de données (30 secondes max)..."
PRET=0
for i in $(seq 1 30); do
    if docker compose exec db mysqladmin ping -h localhost --silent 2>/dev/null; then
        PRET=1
        break
    fi
    echo -n "."
    sleep 1
done
echo ""
[ $PRET -eq 1 ] || err "La base de données ne répond pas après 30 secondes."
ok "Base de données prête"

# Étape 2 : Configurer ERPNext
info "Configuration d'ERPNext (connexions Redis/MariaDB)..."
docker compose --profile setup run --rm configurateur
ok "Configuration terminée"

# Étape 3 : Créer le site BCIT (~5 minutes)
info "Création du site $SITE_NAME (opération longue, ~5 minutes)..."
docker compose --profile setup run --rm creation-site
ok "Site créé avec succès"

# Étape 4 : Démarrer tous les services
info "Démarrage de tous les services..."
docker compose up -d
ok "Tous les services démarrés"

echo ""
echo "============================================================"
echo "  Installation terminée !"
echo "============================================================"
echo ""
echo "  Accès        : http://localhost:${PORT:-8080}"
echo "  Login        : Administrator"
echo "  Mot de passe : $ADMIN_PASSWORD"
echo ""
echo "  Prochaines étapes dans ERPNext :"
echo "  1. Créer la société 'BCIT Formation'"
echo "  2. Sélectionner le plan comptable français"
echo "  3. Ajouter les utilisateurs"
echo ""
echo "  Commandes utiles :"
echo "  Arrêter    : docker compose down"
echo "  Logs       : docker compose logs -f"
echo "  Redémarrer : docker compose restart"
echo "  Mise à jour: docker compose pull && docker compose up -d"
echo ""
