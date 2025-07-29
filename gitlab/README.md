# GitLab Stack avec Runner

Ce stack Docker Compose inclut GitLab CE/EE avec un GitLab Runner configuré pour l'exécution des pipelines CI/CD.

## Configuration

### 1. Variables d'environnement

Copiez le fichier `.env.template` vers `.env` et configurez les variables :

```bash
cp .env.template .env
```

Modifiez les valeurs dans `.env` selon votre environnement :
- `GITLAB_HOSTNAME` : Le nom de domaine de votre GitLab
- `GITLAB_SSH_PORT` : Le port SSH pour GitLab (par défaut 2224)
- `GITLAB_TIMEZONE` : Votre fuseau horaire
- Chemins des données GitLab

### 2. Configuration du Runner

#### Première configuration

1. Copiez le fichier template de configuration du runner :
```bash
mkdir -p runner-config
cp config.toml.template runner-config/config.toml
```

2. Modifiez `runner-config/config.toml` :
   - Remplacez `VOTRE_GITLAB_HOSTNAME` par votre domaine GitLab
   - Remplacez `VOTRE_RUNNER_TOKEN` par le token d'enregistrement

#### Obtenir le token d'enregistrement

**Pour un runner d'instance (recommandé pour les admins) :**
1. Connectez-vous à GitLab en tant qu'administrateur
2. Allez dans **Admin Area** > **CI/CD** > **Runners**
3. Cliquez sur **Register an instance runner**
4. Copiez le token affiché

**Pour un runner de projet :**
1. Allez dans votre projet GitLab
2. **Settings** > **CI/CD** > **Runners**
3. Dans la section **Project runners**, cliquez sur **New project runner**
4. Copiez le token affiché

### 3. Démarrage

```bash
# Démarrer GitLab et le runner
docker compose up -d

# Vérifier les logs
docker compose logs -f gitlab-runner
```

### 4. Enregistrement du runner

Le runner s'enregistrera automatiquement au démarrage s'il trouve un token valide dans sa configuration.

Vous pouvez vérifier l'enregistrement :
- Dans GitLab : **Admin Area** > **CI/CD** > **Runners** (ou dans votre projet)
- Dans les logs : `docker compose logs gitlab-runner`

## Structure des fichiers

```
gitlab/
├── compose.yaml              # Configuration Docker Compose
├── .env.template             # Variables d'environnement (template)
├── .env                      # Variables d'environnement (votre config)
├── config.toml.template      # Configuration runner (template)
├── runner-config/            # Configuration du runner (ignoré par git)
│   └── config.toml          # Configuration active du runner
├── config/                   # Configuration GitLab (ignoré par git)
├── data/                     # Données GitLab (ignoré par git)
└── logs/                     # Logs GitLab (ignoré par git)
```

## Personnalisation du runner

Le fichier `runner-config/config.toml` contient de nombreuses options commentées :

- **Exécuteurs** : Docker (par défaut), shell, etc.
- **Limites de ressources** : CPU, mémoire
- **Volumes Docker** : Pour monter des fichiers/dossiers
- **Cache** : Configuration du cache des builds
- **Sécurité** : Mode privilégié, images autorisées

Consultez les commentaires dans le fichier pour plus de détails.

## Sécurité

⚠️ **Important** :
- Le fichier `runner-config/config.toml` contient des tokens sensibles
- Il est exclu du contrôle de version via `.gitignore`
- Ne jamais commiter ce fichier avec des vrais tokens

## Dépannage

### Le runner ne s'enregistre pas
1. Vérifiez le token dans `runner-config/config.toml`
2. Vérifiez l'URL GitLab dans la configuration
3. Consultez les logs : `docker compose logs gitlab-runner`

### Erreurs Docker-in-Docker
Si vous avez besoin de Docker dans vos jobs CI/CD :
1. Définissez `privileged = true` dans la config du runner
2. Ou utilisez Docker socket mounting (déjà configuré)

### Problèmes de performance
- Augmentez `concurrent` pour plus de jobs simultanés
- Ajustez les limites CPU/mémoire dans la config Docker
- Configurez un cache approprié