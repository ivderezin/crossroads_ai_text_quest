import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'remote_dtos.dart';

part 'openai_api.g.dart';

@RestApi()
abstract class OpenAiApi {
  factory OpenAiApi(Dio dio, {String? baseUrl}) = _OpenAiApi;

  @POST('/chat/completions')
  Future<ChatCompletionResponse> createChatCompletion(
    @Header('authorization') String authorization,
    @Body() ChatCompletionRequest body,
  );

  @GET('/models')
  Future<ModelListResponse> listModels(
    @Header('authorization') String authorization,
  );
}
