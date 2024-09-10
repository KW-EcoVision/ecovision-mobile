import torch.nn as nn
import torch

#https://velog.io/@minkyu4506/PyTorch%EB%A1%9C-YOLOv1-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0 에서 퍼왔는데 달달하네요~
class YOLO(torch.nn.Module):
    def __init__(self, BACK,DEPTH_ZIP):
        super(YOLO, self).__init__()
        self.backbone = BACK
        self.zip = DEPTH_ZIP

        self.conv = nn.Sequential(
            nn.Conv2d(in_channels=512, out_channels=1024, kernel_size=3, padding=1),
            nn.LeakyReLU(),
            nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
            nn.LeakyReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
            nn.LeakyReLU(),
            nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
            nn.LeakyReLU(),
            nn.Flatten()
        )
        if self.zip:
            self.conv = nn.Sequential(
                nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
                nn.LeakyReLU(),
                nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
                nn.LeakyReLU(),
                nn.MaxPool2d(2),
                nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
                nn.LeakyReLU(),
                nn.Conv2d(in_channels=1024, out_channels=1024, kernel_size=3, padding=1),
                nn.LeakyReLU(),
                nn.Flatten()
            )
        self.linear = nn.Sequential(
            nn.Linear(50176, 4096),
            nn.LeakyReLU(),
            nn.Dropout(0.2),
            nn.Linear(4096, 1470)
        )

        # 가중치 초기화
        for m in self.conv.modules():
            if isinstance(m, nn.Conv2d):
                nn.init.normal_(m.weight, mean=0, std=0.01)

        for m in self.linear.modules():
            if isinstance(m, nn.Linear):
                nn.init.normal_(m.weight, mean=0, std=0.01)


    def forward(self, x):
        out = self.backbone(x)
        out = self.conv(out)
        out = self.linear(out)
        out = torch.reshape(out, (-1, 7, 7, 30))
        return out