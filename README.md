# Décodeur de fiche de paie

Application web (une seule page, tout tourne dans le navigateur) qui analyse une fiche de paie française :

- **Résumé en clair** : brut → cotisations → impôt → net versé, coût employeur.
- **Vérification des calculs** : heures × taux, SMIC, brut − cotisations, net imposable, impôt à la source, net payé.
- **Cotisation par cotisation** : recalcul avec les taux légaux 2026 (retraite, CSG/CRDS, maladie, famille, chômage…).
- **Mentions obligatoires** (art. R3243-1 du Code du travail, bulletin clarifié) : ce qui manque.
- **Ligne par ligne** : explication simple de chaque ligne et de qui la paie.
- **Rapport** à copier pour demander des explications à l'employeur.

## Utilisation

Ouvrir `index.html` dans un navigateur, puis déposer le PDF de la fiche de paie (ou coller son texte).
Aucune donnée n'est envoyée : le PDF est lu localement avec pdf.js.

`fichepaie.html` est la source ; `./build.sh` régénère `index.html`.

Les paramètres légaux (SMIC, PMSS) sont modifiables dans la page. Outil d'aide à la lecture, sans valeur juridique.
