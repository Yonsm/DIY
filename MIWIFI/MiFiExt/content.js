
function uncomment(el) {
	const it = document.createNodeIterator(el, NodeFilter.SHOW_COMMENT)
	for (let node; node = it.nextNode();) {
		const content = node.nodeValue.trim()
		if (!content || !node.parentNode) continue
		const div = document.createElement('div')
		div.innerHTML = content
		const parent = node.parentNode
		const nextSibling = node.nextSibling
		parent.removeChild(node)
		while (div.firstChild) {
			parent.insertBefore(div.firstChild, nextSibling)
		}
	}
}

function ipToInt(ip) {
	return ip.split('.').reduce((result, octet, index) => {
		return result + (parseInt(octet) << ((3 - index) * 8));
	}, 0);
}

function tmToSec(tm) {
	let seconds = 0
	const regex = /(\d+)(天|小时|分|秒)/g
	const units = { '天': 86400, '小时': 3600, '分': 60, '秒': 1 }
	for (let match; match = regex.exec(tm);) {
		seconds += parseInt(match[1]) * units[match[2]]
	}
	return seconds
}

var sortRevs = []
function sortTable(tbody, id) {
	const rows = Array.from(tbody.querySelectorAll('tr'))
	rows.sort((row1, row2) => {
		const getEl = (row) => id < 4 ? row.cells[id] : (id % 4 == 0 ? row.querySelector('.name') : row.querySelectorAll('.v')[id % 4 - 1])
		let [t1, t2] = [getEl(row1), getEl(row2)].map(el => el?.textContent.trim() || '')
		if (sortRevs[id]) [t1, t2] = [t2, t1]
		if (t1.includes('.')) {
			return ipToInt(t1) - ipToInt(t2)
		} else if (t1.includes('秒')) {
			return tmToSec(t1) - tmToSec(t2)
		}
		return t1.localeCompare(t2)
	})
	sortRevs[id] = !sortRevs[id]
	tbody.textContent = ''
	rows.forEach(row => tbody.appendChild(row))
}

function sendRequest(call, args) {
	return new Promise((resolve, reject) => {
		const xhr = new XMLHttpRequest()
		xhr.open('POST', `/cgi-bin/luci/;stok=${location.pathname.substring(20, 52)}/api/${call}`)
		xhr.onload = () => {
			if (xhr.status >= 200 && xhr.status < 300) {
				const rsp = JSON.parse(xhr.responseText)
				rsp.code == 0 ? resolve(rsp) : reject(rsp.msg)
			} else {
				reject('请求失败: ' + xhr.status)
			}
		}
		xhr.onerror = () => reject('网络错误，请稍后重试')
		xhr.send(new URLSearchParams(args))
	})
}

async function batchImport(head, text) {
	const items = []
	const router = document.querySelector('[data-ip]')?.dataset.ip || document.querySelector('[name=ip]')?.value || '192.168.31.1'
	const prefix = router.split('.').slice(0, 3).join('.') + '.'
	for (let line of text.trim().split('\n')) {
		const text = line.trim()
		if (!text) return
		const parts = text.split(/\s+/).map(part => part.trim())
		if (parts.length < 3) return alert(`第${index + 1}行: 字段数量不足`)
		const [addr, value, name] = parts
		const ip = addr.includes('.') ? addr : prefix + addr
		if (head == '转发') {
			items.push({ name, proto: parts.length > 4 ? parts[4] : 1, sport: value, ip, dport: parts.length > 3 ? parts[3] : value })
		} else {
			items.push({ ip, mac: value, name })
		}
	}
	if (!items) return alert('请输入数据后再导入')
	try {
		if (head == '转发') {
			for (let item of items) {
				await sendRequest('xqsystem/add_redirect', item)
			}
		} else {
			await sendRequest('xqnetwork/mac_bind', { 'data': JSON.stringify(items) })
		}
		location.reload(1)
	} catch (error) {
		alert(error)
	}
}

function popupDialog(head, desc, tips) {
	const overlay = document.createElement('div')
	overlay.style.cssText = `
		position: fixed; top: 0; left: 0; width: 100%; height: 100%;
		background-color: rgba(0, 0, 0, 0.7); z-index: 2147483647;
		display: flex; justify-content: center; align-items: center;
		backdrop-filter: blur(3px); pointer-events: auto; overflow: hidden;
	`
	document.body.style.overflow = 'hidden'

	const dialog = document.createElement('div')
	const dialogWidth = Math.min(window.innerWidth * 0.7, 800)
	const dialogHeight = Math.min(window.innerHeight * 0.7, 600)

	dialog.style.cssText = `
		background-color: white; padding: 20px; border-radius: 8px;
		width: ${dialogWidth}px; height: ${dialogHeight}px;
		display: flex; flex-direction: column;
		box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
		z-index: 2147483648; position: relative;
	`

	const title = document.createElement('h2')
	title.textContent = '批量添加' + head
	title.style.marginTop = '0'

	const textareaLabel = document.createElement('label')
	textareaLabel.textContent = `每行一个，空格分隔（${desc}）`
	textareaLabel.style.cssText = 'display: block; margin-bottom: 10px;'

	const textarea = document.createElement('textarea')
	textarea.style.cssText = `
		flex: 1; padding: 10px; border: 1px solid #ddd;
		border-radius: 4px; font-family: monospace;
		font-size: 14px; resize: none;
	`
	textarea.placeholder = tips

	const dialogButtons = document.createElement('div')
	dialogButtons.style.cssText = 'display: flex; justify-content: flex-end; gap: 10px; margin-top: 15px;'

	function closeDialog() {
		if (document.body.contains(overlay)) {
			document.body.removeChild(overlay)
		}
		document.body.style.overflow = ''
	}

	const cancelButton = document.createElement('button')
	cancelButton.textContent = '取消'
	cancelButton.style.cssText = 'padding: 10px 20px; background-color: #f1f1f1; border: none; border-radius: 4px; cursor: pointer;'
	cancelButton.addEventListener('click', closeDialog)

	const confirmButton = document.createElement('button')
	confirmButton.textContent = '导入'
	confirmButton.style.cssText = 'padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;'
	confirmButton.addEventListener('click', () => batchImport(head, textarea.value))

	overlay.addEventListener('click', e => e.target === overlay && closeDialog())
	dialog.addEventListener('click', e => e.stopPropagation())
	overlay.addEventListener('keydown', e => {
		if (e.key === 'Escape') closeDialog()
		e.stopPropagation()
	})

	dialogButtons.appendChild(cancelButton)
	dialogButtons.appendChild(confirmButton)
	dialog.appendChild(title)
	dialog.appendChild(textareaLabel)
	dialog.appendChild(textarea)
	dialog.appendChild(dialogButtons)
	overlay.appendChild(dialog)
	document.body.appendChild(overlay)

	textarea.focus()
}

function selectAll() {
	let display = false
	for (let checkbox of document.querySelectorAll('input[type="checkbox"]')) {
		checkbox.checked = !checkbox.checked
		if (!display && checkbox.checked) display = true
	}
	document.getElementById('dellist').style.display = display ? '' : 'none'
}

function init_home(devicesTables) {
	const tables = devicesTables.children
	if (!tables) return console.log('未找到设备表格')

	document.querySelectorAll('.devnetinfo').forEach(uncomment)
	for (let i = 0; i < tables.length; i++) {
		const chs = tables[i].children
		if (chs.length > 1 && chs[1].children.length > 1) {
			const th = chs[0].children[0].children[0]
			const ts = ['名称', '时长', '网址', '硬件']
			for (let j = 0; j < 4; j++) {
				const span = document.createElement('span')
				span.style.cssText = 'cursor:pointer;color:green;font-size:12px;margin:3px'
				span.onclick = () => sortTable(chs[1], 4 + i * 4 + j)
				span.textContent = ts[j]
				th.appendChild(span)
			}
			sortTable(chs[1], 4 + i * 4 + 2)
		}
	}

	return true
}

function init_lannetset(bandlist) {
	// 批量添加按钮
	const addlist = document.getElementById('addlist')
	if (!addlist) return console.log('未找到静态 DHCP 添加按钮')
	const button = addlist.cloneNode(true)
	button.firstChild.innerText = '批量添加'
	button.onclick = () => popupDialog('绑定', '网址 硬件 名称', '1 00:11:22:33:44:55 设备1\n2 AA:BB:CC:DD:EE:FF 设备2')
	addlist.parentElement.appendChild(button)

	// 修改表头
	const ths = bandlist.parentElement.children[0].children[0].children
	ths[0].style.cssText = 'cursor:pointer;text-align:center;'
	ths[0].textContent = '✅'
	ths[0].onclick = selectAll
	for (let i = 1; i <= 3; i++) {
		ths[i].style.cssText = 'cursor:pointer;color:green;'
		ths[i].onclick = () => sortTable(bandlist, i)
	}

	sortTable(bandlist, 2)
	return true
}

function init_nat(natlist_port) {
	const td = natlist_port.lastChild.firstChild
	const button = td.firstChild.cloneNode(true)
	button.firstChild.innerText = '批量添加'
	button.style.marginLeft = '10px'
	button.onclick = (event) => { event.stopPropagation(); popupDialog('转发', '网址 端口 名称 [目标] [协议]', '1 81 WEB1\n2 82 WEB2 80') }
	td.appendChild(button)
	return true
}

function init() {
	const topo = document.querySelector('.goto-topo')
	if (topo) topo.firstChild.href = '/cgi-bin/luci/web/topo'

	const pages = { 'home': 'devicesTables', 'lannetset': 'bandlist', 'nat': 'natlist_port' }
	const page = location.pathname.split('/').pop()
	const node = pages[page]
	if (!node) return console.log('未找到匹配页面')

	const el = document.getElementById(node)
	if (!el) return console.log('未找到匹配元素')
	let success = false
	const observer = new MutationObserver(mutations => {
		for (const mutation of mutations) {
			if (!success && mutation.addedNodes.length > 0) {
				if (success = window['init_' + page](el)) {
					observer.disconnect()
					break
				}
			}
		}
	})
	observer.observe(el, { childList: true })
}

console.log('小米路由器增强功能已加载')
init()
