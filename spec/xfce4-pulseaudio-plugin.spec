Name:           xfce4-pulseaudio-plugin
Version:        0.5.1
Release:        1%{?dist}
Summary:        Pulseaudio control plugin for the Xfce panel

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/panel-plugins/xfce4-pulseaudio-plugin/0.5/xfce4-pulseaudio-plugin-%{version}.tar.xz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  xfce4-panel-devel >= 4.20.0
BuildRequires:  pulseaudio-libs-devel
BuildRequires:  libnotify-devel
BuildRequires:  libcanberra-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Xfce4-pulseaudio-plugin is a Pulseaudio control plugin for the Xfce panel.

%prep
%autosetup

%build
xdt-autogen
%configure
%make_build

%install
%make_install

%find_lang xfce4-pulseaudio-plugin

%files -f xfce4-pulseaudio-plugin.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/xfce4/panel/plugins/libpulseaudio-plugin*
%{_datadir}/xfce4/panel/plugins/pulseaudio.desktop
%{_datadir}/icons/hicolor/*/status/xfce4-pulseaudio-plugin*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 0.5.1-1
- Initial release for Xfce 4.20 compatibility
