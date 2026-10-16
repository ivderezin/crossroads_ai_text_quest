import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_dtos.freezed.dart';
part 'remote_dtos.g.dart';

@freezed
abstract class ChatMessageDto with _$ChatMessageDto {
  const factory ChatMessageDto({
    required String role,
    required String content,
  }) = _ChatMessageDto;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);
}

@freezed
abstract class ModelListResponse with _$ModelListResponse {
  const factory ModelListResponse({@Default([]) List<ModelInfoDto> data}) =
      _ModelListResponse;

  factory ModelListResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelListResponseFromJson(json);
}

@freezed
abstract class ModelInfoDto with _$ModelInfoDto {
  const factory ModelInfoDto({required String id}) = _ModelInfoDto;

  factory ModelInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ModelInfoDtoFromJson(json);
}

@freezed
abstract class AnthropicMessageRequest with _$AnthropicMessageRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory AnthropicMessageRequest({
    required String model,
    required int maxTokens,
    required String system,
    required List<ChatMessageDto> messages,
    String? fallbacks,
  }) = _AnthropicMessageRequest;

  factory AnthropicMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$AnthropicMessageRequestFromJson(json);
}

@freezed
abstract class AnthropicMessageResponse with _$AnthropicMessageResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AnthropicMessageResponse({
    String? stopReason,
    @Default([]) List<AnthropicContentBlock> content,
  }) = _AnthropicMessageResponse;

  factory AnthropicMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$AnthropicMessageResponseFromJson(json);
}

@freezed
abstract class AnthropicContentBlock with _$AnthropicContentBlock {
  const factory AnthropicContentBlock({required String type, String? text}) =
      _AnthropicContentBlock;

  factory AnthropicContentBlock.fromJson(Map<String, dynamic> json) =>
      _$AnthropicContentBlockFromJson(json);
}

@freezed
abstract class ChatCompletionRequest with _$ChatCompletionRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ChatCompletionRequest({
    required String model,
    required List<ChatMessageDto> messages,
    required int maxCompletionTokens,
    ResponseFormatDto? responseFormat,
  }) = _ChatCompletionRequest;

  factory ChatCompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionRequestFromJson(json);
}

@freezed
abstract class ResponseFormatDto with _$ResponseFormatDto {
  const factory ResponseFormatDto({required String type}) = _ResponseFormatDto;

  factory ResponseFormatDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseFormatDtoFromJson(json);
}

@freezed
abstract class ChatCompletionResponse with _$ChatCompletionResponse {
  const factory ChatCompletionResponse({
    @Default([]) List<ChatChoiceDto> choices,
  }) = _ChatCompletionResponse;

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionResponseFromJson(json);
}

@freezed
abstract class ChatChoiceDto with _$ChatChoiceDto {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatChoiceDto({
    String? finishReason,
    ChatChoiceMessageDto? message,
  }) = _ChatChoiceDto;

  factory ChatChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$ChatChoiceDtoFromJson(json);
}

@freezed
abstract class ChatChoiceMessageDto with _$ChatChoiceMessageDto {
  const factory ChatChoiceMessageDto({String? content, String? refusal}) =
      _ChatChoiceMessageDto;

  factory ChatChoiceMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatChoiceMessageDtoFromJson(json);
}
