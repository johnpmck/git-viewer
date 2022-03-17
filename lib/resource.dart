//  A generic class wrapper for API calls.
class Resource<T> {
  Status status;
  T? data;
  String? message;

  Resource.loading(this.message) : status = Status.loading;
  Resource.completed(this.data) : status = Status.completed;
  Resource.error(this.message) : status = Status.error;

  @override
  String toString() => 'Status : $status \n Message : $message \n Data : $data';
}

enum Status { loading, completed, error }
