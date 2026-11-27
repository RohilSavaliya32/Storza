import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            responseType: ResponseType.json,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('╔════════════════════════════════════════════════════════════════════════════');
        debugPrint('║ 🚀 REQUEST: ${options.method} ${options.baseUrl}${options.path}');
        debugPrint('║ 📂 Headers: ${options.headers}');
        if (options.data != null) {
          debugPrint('║ 📦 Body: ${_prettyPrintJson(options.data)}');
        }
        debugPrint('╚════════════════════════════════════════════════════════════════════════════');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('╔════════════════════════════════════════════════════════════════════════════');
        debugPrint('║ ✅ RESPONSE [${response.statusCode}]: ${response.requestOptions.path}');
        debugPrint('║ 📄 Data: ${_prettyPrintJson(response.data)}');
        debugPrint('╚════════════════════════════════════════════════════════════════════════════');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('╔════════════════════════════════════════════════════════════════════════════');
        debugPrint('║ ❌ ERROR [${e.response?.statusCode}]: ${e.requestOptions.path}');
        debugPrint('║ 💬 Message: ${e.message}');
        if (e.response?.data != null) {
          debugPrint('║ 📄 Error Response: ${_prettyPrintJson(e.response?.data)}');
        }
        debugPrint('╚════════════════════════════════════════════════════════════════════════════');
        return handler.next(e);
      },
    ));
  }

  String _prettyPrintJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }

  Dio get dio => _dio;
}
