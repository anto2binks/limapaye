# Décodeur de fiche de paie

Application web (une seule page, tout tourne dans le navigateur) qui analyse les fiches de paie françaises, quel que soit le logiciel qui les produit (TESE/CEA de l'URSSAF, Sage, Silae, PayFit, ADP, Cegid…) :

- **Heures** : heures sup (25 % / 50 %), heures complémentaires (10 % / 25 %), absences, heures en h/min ; comparaison avec les heures notées semaine par semaine.
- **Plusieurs mois** : réduction de cotisations sur heures sup, défiscalisation (7 500 €), net social, paniers.

- **Résumé en clair** : brut → cotisations → impôt → net versé, coût employeur.
- **Vérification des calculs** : heures × taux, SMIC, brut − cotisations, net imposable, impôt à la source, net payé.
- **Cotisation par cotisation** : recalcul avec les taux légaux 2026 (retraite, CSG/CRDS, maladie, famille, chômage…).
- **Mentions obligatoires** (art. R3243-1 du Code du travail, bulletin clarifié) : ce qui manque.
- **Ligne par ligne** : explication simple de chaque ligne et de qui la paie.
- **Rapport** à copier pour demander des explications à l'employeur.

## Utilisation

**En ligne (installable sur l'écran d'accueil)** : https://anto2binks.github.io/fichepaie/ (GitHub Pages, branche `claude/pensive-hypatia-yp4smk`, dossier racine). Une fois ouverte, l'appli fonctionne aussi hors connexion.

**Hors ligne** : `dist/fiche-paie.html`, un seul fichier à ouvrir dans un navigateur.


Ouvrir `index.html` dans un navigateur, puis déposer le PDF de la fiche de paie (ou coller son texte).
Aucune donnée n'est envoyée : le PDF est lu localement avec pdf.js (copie locale dans `vendor/`, version 3.11.174 du paquet npm `pdfjs-dist`).

## Sécurité

- Aucune ressource externe : polices système, pdf.js et moteur de lecture des photos (Tesseract) servis avec la page, pas de statistiques.
- Photos (JPEG, PNG, HEIC) lues sur l'appareil par Tesseract.js 5.1.1 (`vendor/ocr/`, données de langue `fra` 4.0.0_best_int). Correctif appliqué dans `worker.min.js` : nom de langue (`t.code`) au lieu des données (`t.data`) à l'initialisation.
- Les fiches ne sont stockées nulle part (ni serveur, ni navigateur) ; « Tout effacer » vide la page.
- Seule exception, sur demande explicite : l'analyse par Claude, après anonymisation (nom, prénom, adresse, n° de Sécu, IBAN, e-mail, téléphone).
- Ne jamais committer de fiche de paie dans ce dépôt (`*.pdf` est ignoré).

Empreintes SHA-256 :

```
a8e29918d098b2b06e1012bdaeffb4aec0445c5d5654709023e0bd1f442a80e8  vendor/ocr/tesseract.min.js
dffed8e679814a7c3fc4ad8fc3c1bbc8eee7cf76dfa0612641f69314fa1a9734  vendor/ocr/worker.min.js
ce20eda9533cbed1e6c2b4276fbae1e0adc61b6754b5513084be601787b457cf  vendor/ocr/tesseract-core-simd-lstm.wasm.js
8f04aa0cc81e7bde33f80e92fa01a7a665f0b4884d098acf5de9c7104a11dfaa  vendor/ocr/tesseract-core-lstm.wasm.js
d611139672b3752c7097e671e4a1d9209dfd37f2aeb081ef6487fba3351e9255  vendor/ocr/fra.traineddata.gz
5b5799e6f8c680663207ac5b42ee14eed2a406fa7af48f50c154f0c0b1566946  vendor/pdf.min.js
feabdf309770ed24bba31a5467836cdc8cf639c705af27d52b585b041bb8527b  vendor/pdf.worker.min.js
```

`fichepaie.html` est la source ; `./build.sh` régénère `index.html`, `sw.js` et `dist/fiche-paie.html`.

Les paramètres légaux (SMIC, PMSS) sont modifiables dans la page. Outil d'aide à la lecture, sans valeur juridique.
