# XÁC ĐỊNH KHOÁ CHÍNH CỦA FLIGHTS

import pandas as pd

# 1. Đọc tệp dữ liệu
try:
    file_path = 'dataset_small\\filtered_flights_3.csv'
    df = pd.read_csv(file_path)
    total_records = len(df)
    print(f"Tổng số bản ghi (hàng) trong tập dữ liệu: {total_records}\n")

    # 2. Kiểm tra tính duy nhất cho các cột đơn lẻ (Khóa Chính Đơn)

    # Ứng viên A: FLIGHT_NUMBER (Số hiệu chuyến bay)
    unique_flights = df['FLIGHT_NUMBER'].nunique()
    print(f"Số lượng FLIGHT_NUMBER duy nhất: {unique_flights}")
    if unique_flights == total_records:
        print("-> ✅ FLIGHT_NUMBER là Khóa Chính (vì nó duy nhất).\n")
    else:
        # Số hiệu chuyến bay (FLIGHT_NUMBER) thường không duy nhất, vì cùng một số hiệu 
        # sẽ được sử dụng cho nhiều ngày khác nhau.
        print("-> ❌ FLIGHT_NUMBER không phải là Khóa Chính.\n")

    # Ứng viên B: TAIL_NUMBER (Số đuôi máy bay)
    unique_tails = df['TAIL_NUMBER'].nunique()
    print(f"Số lượng TAIL_NUMBER duy nhất: {unique_tails}")
    if unique_tails == total_records:
        print("-> ✅ TAIL_NUMBER là Khóa Chính (vì nó duy nhất).\n")
    else:
        # Số đuôi máy bay (TAIL_NUMBER) cũng không duy nhất, vì một máy bay 
        # thực hiện nhiều chuyến bay khác nhau.
        print("-> ❌ TAIL_NUMBER không phải là Khóa Chính.\n")

    # 3. Kiểm tra tính duy nhất cho Khóa Tổng hợp (Composite Key)

    # Khóa Tổng hợp tiềm năng nhất: (DATE, AIRLINE, FLIGHT_NUMBER)
    # Khóa này đại diện cho "Một chuyến bay cụ thể của hãng A vào ngày B"
    
    # Tạo một cột đại diện cho Khóa Tổng hợp
    # df['Composite_Key'] = df['DATE'].astype(str) + '_' + df['AIRLINE'] + '_' + df['FLIGHT_NUMBER'].astype(str)
    df['Composite_Key'] = df['DATE'].astype(str) + '_' + df['AIRLINE'] + '_' + df['FLIGHT_NUMBER'].astype(str) + '_' + df['SCHEDULED_DEPARTURE'].astype(str)
    # df['Composite_Key'] = df['DATE'].astype(str) + '_' + df['FLIGHT_NUMBER'].astype(str) + '_' + df['SCHEDULED_DEPARTURE'].astype(str)

    # Kiểm tra tính duy nhất của khóa tổng hợp
    unique_composite_keys = df['Composite_Key'].nunique()
    
    print("\n--- Kiểm tra Khóa Tổng hợp ---")
    # print(f"Số lượng Khóa Tổng hợp (DATE, AIRLINE, FLIGHT_NUMBER) duy nhất: {unique_composite_keys}")
    print(f"Số lượng Khóa Tổng hợp (DATE, AIRLINE, FLIGHT_NUMBER, SCHEDULED_DEPARTURE) duy nhất: {unique_composite_keys}")
    # print(f"Số lượng Khóa Tổng hợp (DATE, FLIGHT_NUMBER, SCHEDULED_DEPARTURE) duy nhất: {unique_composite_keys}")
    
    if unique_composite_keys == total_records:
        # print("-> ✅ Khóa Tổng hợp **(DATE, AIRLINE, FLIGHT_NUMBER)** là Khóa Chính của tập dữ liệu này.")
        print("-> ✅ Khóa Tổng hợp **(DATE, AIRLINE, FLIGHT_NUMBER, SCHEDULED_DEPARTURE)** là Khóa Chính của tập dữ liệu này.")
        # print("-> ✅ Khóa Tổng hợp **(DATE, FLIGHT_NUMBER, SCHEDULED_DEPARTURE)** là Khóa Chính của tập dữ liệu này.")
        print("   Mỗi bản ghi đại diện cho một sự kiện chuyến bay cụ thể được xác định DUY NHẤT.")
    else:
        print("-> ❌ Khóa Tổng hợp (DATE, AIRLINE, FLIGHT_NUMBER) không duy nhất.")
        print("   Cần xem xét thêm các cột khác (ví dụ: giờ khởi hành SCHEDULED_DEPARTURE) để thêm vào Khóa Tổng hợp.")

    # (Tùy chọn) Khóa Tổng hợp khác: (DATE, ORIGIN_AIRPORT, DESTINATION_AIRPORT, SCHEDULED_DEPARTURE)
    # Khóa này đại diện cho "Một tuyến bay cụ thể theo lịch trình vào ngày và giờ đó"

except FileNotFoundError:
    print(f"Lỗi: Không tìm thấy tệp {file_path}. Vui lòng đảm bảo tệp đã được tải lên.")
except Exception as e:
    print(f"Đã xảy ra lỗi trong quá trình xử lý: {e}")