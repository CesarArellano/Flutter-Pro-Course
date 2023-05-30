import 'package:dio/dio.dart';
import 'package:yes_no_app/domain/entities/message.dart';

import '../../infrastructure/models/get_yes_no_aswer.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    final response = await _dio.get('https://yesno.wtf/api');

    final decodedData = YesNoModel.fromJson(response.data);

    return decodedData.toMessageEntity();
  }
}