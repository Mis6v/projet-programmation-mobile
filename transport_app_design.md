# Conception de l'Application de Transport (Flutter)

## Objectif
Créer une interface utilisateur fluide et moderne pour une société de transport, permettant la recherche et la réservation de trajets.

## Architecture du Projet
L'application suivra une structure modulaire pour faciliter la maintenance :
- `lib/models/` : Modèles de données (Trip, Booking).
- `lib/screens/` : Écrans de l'application.
- `lib/widgets/` : Composants réutilisables (Cartes de trajet, Boutons personnalisés).
- `lib/theme/` : Couleurs, polices et styles globaux.
- `lib/main.dart` : Configuration de la navigation et point d'entrée.

## Écrans Principaux
1. **Écran d'Accueil (Home)** :
   - Barre de recherche rapide.
   - Liste des trajets populaires ou récents.
   - Menu de navigation (Bottom Navigation Bar).

2. **Recherche de Voyages** :
   - Sélection de la ville de départ et de destination.
   - Sélecteur de date.
   - Nombre de passagers.

3. **Résultats de Recherche** :
   - Liste de cartes affichant l'heure, le prix et le type de véhicule.
   - Filtres (Prix, Heure de départ).

4. **Détails du Trajet & Réservation** :
   - Informations complètes sur le trajet.
   - Sélection de place (si applicable).
   - Formulaire de réservation rapide.

5. **Confirmation de Réservation** :
   - Résumé du billet.
   - Code QR ou numéro de réservation.

## Palette de Couleurs (Proposée)
- **Primaire** : Bleu Transport (#1A237E) ou Vert (#2E7D32) pour inspirer la confiance.
- **Secondaire** : Orange (#F57C00) pour les boutons d'action (Appel à l'action).
- **Fond** : Gris très clair (#F5F5F5).
