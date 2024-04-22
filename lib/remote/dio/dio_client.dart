import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_const.dart';
import 'logging_interceptor.dart';

final dio = Provider((ref) => DioClient(Urls.HOST));

class DioClient {
  final String baseUrl;
  LoggingInterceptor? loggingInterceptor = LoggingInterceptor();

  Dio dio = Dio();
  String? token = "";

  DioClient(
    this.baseUrl,
  ) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout =  const Duration(seconds: 15)
      ..options.receiveTimeout =  const Duration(seconds: 15)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'auth': 'gxey9ui8konpsB0QZFKy3KYk1Ct1LF'
      };
    dio.interceptors.add(loggingInterceptor!);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  getHeaders() {
    Map<String, String> header = {
      'Accept': 'application/json',
      "Authorization": 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    return header;
  }

  Future<dynamic> postFile({required FormData body, String url = ''}) async {
    Response result;
    try {
      result = await dio.post(url,
          data: body,
          options: Options(
            headers: getHeaders(),
          ));
      return result;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data.toString());

        print(url);
      }
      return null;
    }
  }
}
