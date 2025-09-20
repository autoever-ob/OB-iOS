import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("이용 약관")
                    .font(.largeTitle).bold()
                    .padding(.top)

                Text(intro)
                    .font(.callout)
                    .foregroundStyle(.secondary)

                Divider()

                Text(termsText)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .navigationTitle("이용 약관")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("닫기") { dismiss() }
            }
        }
    }

    private var intro: String {
        "캠픽 서비스를 이용해 주셔서 감사합니다. 아래 약관을 주의 깊게 읽어보시기 바랍니다. 본 약관은 서비스 이용과 관련된 권리, 의무 및 책임 사항을 규정합니다."
    }

    private var termsText: String {
        // Placeholder long terms text. Replace with real content when ready.
        (
            [
                "제1조 (목적) 본 약관은 캠픽(이하 ‘회사’)이 제공하는 서비스의 이용 조건 및 절차, 회사와 이용자의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.",
                "제2조 (용어의 정의) 본 약관에서 사용하는 용어의 정의는 관련 법령 및 서비스 안내에서 정하는 바에 따릅니다.",
                "제3조 (약관의 게시와 개정) 회사는 관련 법령을 위반하지 않는 범위에서 본 약관을 개정할 수 있습니다. 개정 시 사전 공지합니다.",
                "제4조 (서비스의 제공) 회사는 다음과 같은 서비스를 제공합니다: (1) 캠핑용품 거래 중개, (2) 기타 부가 서비스.",
                "제5조 (이용계약의 성립) 이용계약은 이용자가 약관에 동의하고 회원가입 절차를 완료함으로써 성립합니다.",
                "제6조 (개인정보 보호) 회사는 관련 법령에 따라 이용자의 개인정보를 보호하기 위해 노력합니다.",
                "제7조 (이용자의 의무) 이용자는 관계 법령과 본 약관을 준수하여야 하며, 서비스의 정상적인 운영을 방해해서는 안 됩니다.",
                "제8조 (수수료 및 결제) 거래 수수료, 할인, 환불 등 결제와 관련된 사항은 별도의 정책에 따릅니다.",
                "제9조 (책임의 제한) 회사는 천재지변, 불가항력 등으로 서비스를 제공할 수 없는 경우 책임을 지지 않습니다.",
                "제10조 (준거법 및 관할) 본 약관은 대한민국 법률에 따르며, 분쟁 발생 시 관할 법원에 따릅니다.",
                "부칙: 본 약관은 공지한 날로부터 시행합니다."
            ]
            .joined(separator: "\n\n")
        )
    }
}

#Preview {
    NavigationStack {
        TermsView()
    }
}
