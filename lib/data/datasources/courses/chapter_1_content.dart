import 'package:matheasy_sn/domain/entities/course_content/course_content.dart';

/// Contenu du chapitre 1: Racine Carrée
/// Ce fichier contient la transcription complète du cours
/// basé sur les images fournies.

class Chapter1Content {
  static const String title = "RACINE CARRÉE D'UN NOMBRE POSITIF";

  static final List<CourseContent> content = [
    const TitleContent("I. DÉFINITION ET NOTATION", level: 1),
    const ParagraphContent(
        "Le chapitre est consacré à la notion de racine carrée d'un nombre positif et à ses propriétés."),
    ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent(
            "Soit a un nombre positif. La racine carrée de a est le nombre positif, noté √a, dont le carré est a."),
        MathFormulaContent(r"$(\sqrt{a})^2 = a$"),
      ],
    ),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\sqrt{25} = 5 \quad \text{car} \quad 5^2 = 25$"),
        MathFormulaContent(
            r"$\sqrt{0} = 0 \quad \text{car} \quad 0^2 = 0$"),
        MathFormulaContent(
            r"$\sqrt{1} = 1 \quad \text{car} \quad 1^2 = 1$"),
        MathFormulaContent(
            r"$\sqrt{81} = 9 \quad \text{car} \quad 9^2 = 81$"),
      ],
    ),
    const TitleContent("II. PROPRIÉTÉS", level: 1),
    const TitleContent("1) Carré d'une racine carrée", level: 2),
    ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent(
            "Pour tout nombre positif a, on a :"),
        MathFormulaContent(r"$(\sqrt{a})^2 = a$"),
      ],
    ),
     ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$(\sqrt{3})^2 = 3$"),
        MathFormulaContent(r"$(\sqrt{16})^2 = 16$"),
      ],
    ),
    const TitleContent("2) Racine carrée d'un carré", level: 2),
    ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent("Pour tout nombre positif a, on a :"),
        MathFormulaContent(r"$\sqrt{a^2} = a$"),
      ],
    ),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\sqrt{4^2} = 4$"),
        MathFormulaContent(r"$\sqrt{15^2} = 15$"),
      ],
    ),
    const TitleContent("3) Produit de racines carrées", level: 2),
    ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent(
            "Pour tous nombres positifs a et b, on a :"),
        MathFormulaContent(r"$\sqrt{a \times b} = \sqrt{a} \times \sqrt{b}$"),
      ],
    ),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\sqrt{25 \times 16} = \sqrt{25} \times \sqrt{16} = 5 \times 4 = 20$"),
      ],
    ),
    const TitleContent("4) Quotient de racines carrées", level: 2),
     ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent(
            "Pour tous nombres positifs a et b (avec b non nul), on a :"),
        MathFormulaContent(r"$\sqrt{\frac{a}{b}} = \frac{\sqrt{a}}{\sqrt{b}}$"),
      ],
    ),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\sqrt{\frac{36}{25}} = \frac{\sqrt{36}}{\sqrt{25}} = \frac{6}{5}$"),
      ],
    ),
    const TitleContent("III. CALCULS AVEC LES RACINES CARRÉES", level: 1),
    const TitleContent("1) Développement", level: 2),
    ARetenirContent(
      title: "À retenir",
      content: [
        const ParagraphContent("Pour tous nombres positifs a et b :"),
        MathFormulaContent(r"$(\sqrt{a} + \sqrt{b})^2 = a + b + 2\sqrt{ab}$"),
        MathFormulaContent(r"$(\sqrt{a} - \sqrt{b})^2 = a + b - 2\sqrt{ab}$"),
        MathFormulaContent(r"$(\sqrt{a} - \sqrt{b})(\sqrt{a} + \sqrt{b}) = a - b$"),
      ],
    ),
    ExampleContent(
      title: "Exemple :",
      content: [
        const ParagraphContent("Développer et simplifier :"),
        MathFormulaContent(r"$(\sqrt{3} + \sqrt{2})^2 = (\sqrt{3})^2 + 2\sqrt{3}\sqrt{2} + (\sqrt{2})^2 = 3 + 2\sqrt{6} + 2 = 5 + 2\sqrt{6}$"),
      ],
    ),
    const TitleContent("2) Simplification d'expressions", level: 2),
    const ParagraphContent("Pour simplifier une expression contenant des racines carrées, on utilise les propriétés précédentes pour extraire les carrés parfaits de sous la racine."),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\sqrt{18} = \sqrt{9 \times 2} = \sqrt{9} \times \sqrt{2} = 3\sqrt{2}$"),
        MathFormulaContent(r"$\sqrt{50} - \sqrt{32} = \sqrt{25 \times 2} - \sqrt{16 \times 2} = 5\sqrt{2} - 4\sqrt{2} = \sqrt{2}$"),
      ],
    ),
    const TitleContent("3) Rendre rationnel un dénominateur", level: 2),
    const ParagraphContent("Pour rendre rationnel le dénominateur d'une fraction, on multiplie le numérateur et le dénominateur par l'expression conjuguée du dénominateur."),
    ExampleContent(
      title: "Exemple :",
      content: [
        MathFormulaContent(r"$\frac{2}{\sqrt{3}} = \frac{2 \times \sqrt{3}}{\sqrt{3} \times \sqrt{3}} = \frac{2\sqrt{3}}{3}$"),
        MathFormulaContent(r"$\frac{1}{\sqrt{5} - 2} = \frac{1 \times (\sqrt{5} + 2)}{(\sqrt{5} - 2)(\sqrt{5} + 2)} = \frac{\sqrt{5} + 2}{5 - 4} = \sqrt{5} + 2$"),
      ],
    ),
    const TitleContent("IV. EXERCICE D'APPLICATION", level: 1),
    const McqContent(
      question: r"Quelle est la valeur de $(\sqrt{8} + \sqrt{2})^2$ ?",
      options: ["10", "18", "12"],
      correctOptionIndex: 1,
    ),
     const McqContent(
      question: r"La simplification de $\sqrt{50} - \sqrt{18}$ est :",
      options: [r"$2\sqrt{2}$", r"$\sqrt{32}$", r"$8\sqrt{2}$"],
      correctOptionIndex: 0,
    ),
  ];
}
