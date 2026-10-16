import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'remote_dtos.dart';

part 'anthropic_api.g.dart';

@RestApi()
abstract class AnthropicApi {
  factory AnthropicApi(Dio dio, {String? baseUrl}) = _AnthropicApi;

  @POST('/messages')
  Future<AnthropicMessageResponse> createMessage(
    @Header('x-api-key') String apiKey,
    @Header('anthropic-version') String version,
    @Body() AnthropicMessageRequest body, {
    @Header('anthropic-beta') String? beta,
  });

  @GET('/models')
  Future<ModelListResponse> listModels(
    @Header('x-api-key') String apiKey,
    @Header('anthropic-version') String version, {
    @Query('limit') int limit = 1000,
  });
}
