class ProductValidator {
  //validador das imagens
  String validateImages(List images) {
    if (images.isEmpty) return 'Adiciona imagens do produto';
    return null;
  }

  //validator do title
  String validateTitle(String text) {
    if (text.isEmpty) return 'Preencha o título do produto';
    return null;
  }

  //valitador da descrição
  String validateDescription(String text) {
    if (text.isEmpty) return 'Preencha a descrição do produto';
    return null;
  }

  //validator preço
  String validatePrice(String text) {
    double price = double.tryParse(text);

    if (price != null) {
      if (!text.contains('.') || text.split('.')[1].length != 2) {
        return 'Utilize 2 casas decimais';
      }
    } else {
      return 'Preço inválido';
    }
    return null;
  }
}
