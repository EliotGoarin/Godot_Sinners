# Godot Game :  Sinners

[![Engine](https://img.shields.io/badge/Godot-4.4-blue)](https://godotengine.org/)
[![Status](https://img.shields.io/badge/status-Work_in_Progress-orange)](#)
[![License](https://img.shields.io/badge/license-TBD-lightgrey)](#)

**Sinners** est un petit jeu d’apprentissage réalisé avec **Godot 4.4**.  
Objectif : expérimenter et mettre en place les **mécaniques de base** d’un action-platformer/top‑down (selon scènes) : **mouvements du joueur**, **IA de boss**, **menus**, **inventaire**, **pickups**, **projectiles**, etc.  
Le dépôt sert de **bac à sable** pour tester des idées et structurer une base saine avant de passer à des niveaux “réels” et à une direction artistique plus aboutie.

---

## Sommaire
- [Aperçu des fonctionnalités](#aperçu-des-fonctionnalités)
- [Captures / Vidéos](#captures--vidéos)
- [Contrôles](#contrôles)
- [Démarrage rapide](#démarrage-rapide)
- [Structure du projet](#structure-du-projet)
- [Notes de dev](#notes-de-dev)
- [Roadmap](#roadmap)
- [Problèmes connus](#problèmes-connus)
- [Contribuer](#contribuer)
- [Licence](#licence)
- [Crédits](#crédits)

---

## Aperçu des fonctionnalités

- **Player**
  - Déplacements, saut / dash / dodge (selon scènes).
  - **Attaque** de mêlée et **projectiles** (ex. Fireball).
  - Gestion de **points de vie** et feedback via **healthbar**.
- **Boss / Ennemis**
  - Zones d’**aggro/attaque** (Area2D) et logique d’**attaque** synchronisée avec l’animation.
  - États simples (IDLE / CHASE / ATTACK) posant la base d’une FSM.
- **Inventaire & Pickups**
  - Ramassage d’armes/objets (**coin**, **arme**, **fireball_pickup**), UI d’inventaire minimale.
- **Menus**
  - Écran principal (**main_menu**), navigation de base.
- **Scènes de test**
  - Plusieurs scènes pour itérer rapidement : `Scenes/game.tscn`, `Scenes/main_menu.tscn`, `Scenes/boss_1.tscn`, `Scenes/player.tscn`, etc.

> Remarque : ce dépôt est un **work in progress**. Le jeu n’a pas d’intention finale “polishée” à ce stade : l’idée est d’apprendre en itérant.


---

## Démarrage rapide

### Prérequis
- **Godot 4.4** (Forward+). Téléchargez l’éditeur correspondant à votre OS.

### Lancer le projet
1. **Cloner** le dépôt :
   ```bash
   git clone https://github.com/<votre-utilisateur>/<votre-repo>.git
   cd <votre-repo>
   ```
2. **Ouvrir** le dossier racine dans Godot (`project.godot`).
3. **Run (F5)**.  
   - Si la scène principale n’est pas configurée, **ouvrez** `Scenes/game.tscn` ou `Scenes/main_menu.tscn` puis **Run Current Scene (F6)**.

### Export (build)
- Installez les **Export Templates** Godot 4.4 (Editor → Manage Export Templates).
- Project → **Export** → ajoutez vos plateformes (Windows/Linux/macOS/Web) et exportez.

---

## Structure du projet

```
sinners/
├─ project.godot
├─ Scenes/
│  ├─ game.tscn
│  ├─ main_menu.tscn
│  ├─ boss_1.tscn
│  ├─ player.tscn
│  └─ … (coin, fireball, healthbar, etc.)
├─ Scripts/
│  ├─ Combat_entity.gd
│  ├─ healthbar.gd
│  ├─ Boss/
│  │  └─ boss_1.gd
│  ├─ Player/
│  │  ├─ player.gd
│  │  ├─ attack_area.gd
│  │  └─ fireball.gd
│  ├─ Pickups/
│  │  ├─ coin_pickup.gd
│  │  ├─ arme_pickup.gd
│  │  └─ fireball_pickup.gd
│  ├─ Inventory/
│  │  ├─ inventory.gd
│  │  ├─ Inventory_item.gd
│  │  ├─ inv_slot.gd
│  │  └─ inv_ui.gd
│  └─ Menu/
│     └─ main_menu.gd
└─ docs/
   └─ media/  (captures à créer)
```

---

## Roadmap

- **Niveaux** “réels” : layout jouable, progression, checkpoints, téléporteurs.
- **Direction artistique** : tilesets, personnages, VFX/SFX, UI propre.
- **Boss patterns** : IA complexe, télégraphie claire, phase 2, projectiles pattern, vulnérabilités.
- **Système d’armes** : dégâts, cadence, portée, stat mods, upgrade.
- **Inventaire avancé** : catégories, tooltips, drag & drop, raccourcis.
- **Audio** : SFX actions/joueur, musique, mixage de base.
- **Sauvegarde** : système de save/load (ConfigFile, JSON, autoload).
- **Options** : remapping des touches, volume, vidéo.
- **Contrôleur** : support manette, vibrations.
- **Builds** : exports Windows/macOS/Web + CI (GitHub Actions).



---

## Licence

MIT 

---

## Crédits

- Moteur : [Godot Engine](https://godotengine.org/).
- Assets & inspirations : placeholders et ressources d’étude (ajouter les crédits si vous importez des packs externes).

---

**Contact** : questions, suggestions et retours via les Issues GitHub du repo.
