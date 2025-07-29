#!/bin/bash
# Script de configuration initiale du GitLab Runner

echo "🚀 Configuration du GitLab Stack avec Runner"

# Vérifier si .env existe
if [ ! -f ".env" ]; then
    echo "📋 Copie du fichier .env.template vers .env..."
    cp .env.template .env
    echo "✅ Fichier .env créé. Modifiez-le avec vos paramètres."
else
    echo "✅ Fichier .env existe déjà."
fi

# Créer le dossier runner-config s'il n'existe pas
if [ ! -d "runner-config" ]; then
    echo "📁 Création du dossier runner-config..."
    mkdir -p runner-config
fi

# Vérifier si config.toml existe
if [ ! -f "runner-config/config.toml" ]; then
    echo "📋 Copie du template de configuration du runner..."
    cp config.toml.template runner-config/config.toml
    echo "✅ Configuration du runner créée dans runner-config/config.toml"
    echo "⚠️  IMPORTANT: Modifiez runner-config/config.toml avec :"
    echo "   - Votre URL GitLab (VOTRE_GITLAB_HOSTNAME)"
    echo "   - Votre token d'enregistrement du runner (VOTRE_RUNNER_TOKEN)"
else
    echo "✅ Configuration du runner existe déjà."
fi

echo ""
echo "📖 Prochaines étapes :"
echo "1. Modifiez .env avec vos paramètres GitLab"
echo "2. Modifiez runner-config/config.toml avec votre URL et token"
echo "3. Lancez le stack : docker compose up -d"
echo ""
echo "📚 Consultez README.md pour plus de détails sur la configuration."