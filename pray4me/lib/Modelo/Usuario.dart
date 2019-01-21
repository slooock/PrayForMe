
class Usuario{


  String _idFirebase;
  String _idSistemaLogin;
  String _senderName;
  String _senderPhotoUrl;
  int _quantPedidos;
  int _quantAgradecimentos;

  String get idFirebase => _idFirebase;
  String get idSistemaLogin => _idSistemaLogin;
  String get senderName => _senderName;
  String get senderPhotoUrl => _senderPhotoUrl;
  int get quantPedidos => _quantPedidos;
  int get quantAgradecimentos => _quantAgradecimentos;

  set quantPedidos(int quantPedidos){
    _quantPedidos = quantPedidos;
  }

  set quantAgradecimentos(int quantAgradecimentos){
    _quantAgradecimentos = quantAgradecimentos;
  }

  set idFirebase(String idFirebase){
    _idFirebase = idFirebase;
  }

  set idSistemaLogin(String idSistemaLogin){
    _idSistemaLogin = idSistemaLogin;
  }

  set senderName(String senderName){
    _senderName = senderName;
  }

  set senderPhotoUrl(String senderPhotoUrl){
    _senderPhotoUrl = senderPhotoUrl;
  }

}