import os


#Transformers bỏ qua TensorFlow, chỉ dùng PyTorch
os.environ["TRANSFORMERS_NO_TF"] = "1"
os.environ["USE_TF"] = "0"

from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image
import torch
from transformers import pipeline
from disease_info_db import disease_info


MODEL_NAME = "linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification"

#Dùng GPU
DEVICE = 0 if torch.cuda.is_available() else -1

print(f"Đang load model {MODEL_NAME} trên device = {DEVICE} ...")
classifier = pipeline(
    "image-classification",
    model=MODEL_NAME,
    device=DEVICE,
)
print("Load model xong.")

app = Flask(__name__)
CORS(app)


# Dictionary ánh xạ tên bệnh sang tiếng Việt
disease_translations = {
    "Apple Scab": "Táo bị ghẻ",
    "Apple with Black Rot": "Táo bị thối đen",
    "Healthy Blueberry Plant": "Cây việt quất khỏe mạnh",
    "Corn (Maize) with Northern Leaf Blight": "Ngô bị cháy lá phương Bắc",
    "Corn (Maize) with Cercospora and Gray Leaf Spot": "Ngô bị đốm lá Cercospora và đốm xám",
    "Healthy Corn (Maize) Plant": "Cây ngô khỏe mạnh",
    "Grape with Black Rot": "Nho bị thối đen",
    "Grape with Esca (Black Measles)": "Nho bị bệnh Esca (mụn đen)",
    "Grape with Isariopsis Leaf Spot": "Nho bị đốm lá Isariopsis",
    "Orange with Citrus Greening": "Cam bị vàng lá Greening",
    "Peach with Bacterial Spot": "Đào bị đốm vi khuẩn",
    "Healthy Peach Plant": "Cây đào khỏe mạnh",
    "Healthy Bell Pepper Plant": "Cây ớt chuông khỏe mạnh",
    "Bell Pepper with Bacterial Spot": "Ớt chuông bị đốm vi khuẩn",
    "Potato with Early Blight": "Khoai tây bị cháy lá sớm",
    "Healthy Soybean Plant": "Cây đậu nành khỏe mạnh",
    "Strawberry with Leaf Scorch": "Dâu tây bị cháy lá",
    "Tomato with Bacterial Spot": "Cà chua bị đốm vi khuẩn",
    "Tomato with Early Blight": "Cà chua bị cháy lá sớm",
    "Healthy Tomato Plant": "Cây cà chua khỏe mạnh",
    "Tomato with Late Blight": "Cà chua bị cháy lá muộn",
    "Tomato with Target Spot": "Cà chua bị đốm mục tiêu",
    "Tomato with Leaf Mold": "Cà chua bị mốc lá",
    "Tomato with Spider Mites or Two-spotted Spider Mite": "Cà chua bị nhện đỏ hoặc nhện hai chấm",
    "Tomato Mosaic Virus": "Cà chua bị virus khảm",
    "Tomato Yellow Leaf Curl Virus": "Cà chua bị virus xoăn vàng lá",
    "Healthy Cherry Plant": "Cây anh đào khỏe mạnh",
    "Corn (Maize) with Common Rust": "Ngô bị gỉ sắt thông thường",
    "Healthy Raspberry Plant": "Cây mâm xôi khỏe mạnh",
    "Tomato with Septoria Leaf Spot": "Cà chua bị đốm lá Septoria",
    "Cherry with Powdery Mildew": "Anh đào bị phấn trắng",
    "Squash with Powdery Mildew": "Bí ngòi bị phấn trắng",
    "Healthy Apple": "Quả táo khỏe mạnh",
    "Healthy Strawberry Plant": "Cây dâu tây khỏe mạnh",
    "Potato with Late Blight": "Khoai tây bị cháy lá muộn",
    "Cedar Apple Rust": "Táo bị gỉ sắt tuyết tùng",
    "Healthy Grape Plant": "Cây nho khỏe mạnh",
    "Healthy Potato Plant": "Cây khoai tây khỏe mạnh",
    # Thêm các bệnh khác ở đây
}

#làm đẹp label
def prettify_label(label_raw: str) -> str:
    pretty = label_raw.replace("___", " - ").replace("_", " ")
    return pretty

# Dịch tên bệnh sang tiếng Việt
def translate_disease_name(label_en: str) -> str:
    return disease_translations.get(label_en, label_en)

def predict_image_pil(img: Image.Image):
    img = img.convert("RGB")
    #top-1
    outputs = classifier(img, top_k=1)

    if not isinstance(outputs, list) or len(outputs) == 0:
        raise RuntimeError("Model không trả về kết quả nào.")

    top = outputs[0]
    label_raw = top.get("label")
    score = float(top.get("score", 0.0))
    return label_raw, score

@app.route("/predict", methods=["POST"])
def predict_api():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files["image"]

    try:
        img = Image.open(file.stream)
    except Exception as e:
        return jsonify({"error": f"Cannot read image: {e}"}), 400


    try:
        label_raw, confidence = predict_image_pil(img)
    except Exception as e:
        return jsonify({"error": f"Prediction error: {e}"}), 500

    label_pretty = prettify_label(label_raw)
    label_vi = translate_disease_name(label_pretty)
    
    # Log để debug
    print(f"label_raw: {label_raw}")
    print(f"label_pretty: {label_pretty}")
    print(f"label_vi: {label_vi}")
    print(f"disease_info keys: {list(disease_info.keys())}")
    
    # Lấy thông tin chi tiết bệnh
    disease_detail = disease_info.get(label_pretty, {
        "characteristics": "Không có thông tin chi tiết",
        "causes": "Không có thông tin chi tiết",
        "prevention": "Không có thông tin chi tiết",
        "treatment": "Không có thông tin chi tiết"
    })

    #model không ổn thì trả status cảnh báo
    if confidence < 0.6:
        status = "Kết quả không chắc chắn, vui lòng chụp lá rõ hơn / gần hơn."
    else:
        status = "OK"

    return jsonify({
        "label": label_pretty,          # Tên bệnh đã làm đẹp (tiếng Anh)
        "label_vi": label_vi,           # Tên bệnh tiếng Việt
        "confidence": confidence,   
        "label_raw": label_raw,     
        "status": status,
        "disease_detail": disease_detail  # Thông tin chi tiết bệnh
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
